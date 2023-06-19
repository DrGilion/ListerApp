import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';
import 'package:lister_app/model/failure.dart';
import 'package:lister_app/model/item_with_tags.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/util/logging.dart';
import 'package:provider/provider.dart';

class PersistenceService {
  static PersistenceService of(BuildContext context) => Provider.of<PersistenceService>(context, listen: false);

  final ListerDatabase database;

  PersistenceService(this.database);

  //#region Lists

  Future<Either<Failure, List<ListerList>>> getListsSimple() async {
    try {
      final query = database.select(database.listerListTable).get();
      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerList>> findListByName(String name) async {
    try {
      final query = (database.select(database.listerListTable)..where((tbl) => tbl.name.equals(name))).getSingle();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerList>> createList(String name, Color color) async {
    try {
      final query = database
          .into(database.listerListTable)
          .insertReturning(ListerListTableCompanion.insert(name: name, color: color));

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerList>> updateList(int listId, {String? newName, Color? newColor}) async {
    try {
      final query = (database.update(database.listerListTable)..where((tbl) => tbl.id.equals(listId)))
          .writeReturning(ListerListTableCompanion(name: Value.ofNullable(newName), color: Value.ofNullable(newColor)));

      return Right((await query).first);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteList(int listId) async {
    try {
      final deletedItems =
          await (database.delete(database.listerItemTable)..where((tbl) => tbl.listId.equals(listId))).go();
      logger.i('deleted $deletedItems items');
      final result = await (database.delete(database.listerListTable)..where((tbl) => tbl.id.equals(listId))).go();
      if (result == 1) {
        return Right(result);
      } else {
        return Left(Failure('No lists deleted', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  //#endregion Lists
  //#region Items

  Future<Either<Failure, List<ListerItem>>> getListerItems(
      {required int listId,
      String searchString = '',
      required String sortField,
      required SortDirection sortDirection}) async {
    try {
      final query = (database.select(database.listerItemTable)
            ..where((tbl) {
              var condition = tbl.listId.equals(listId);
              if (searchString.isNotEmpty) {
                condition &= tbl.name.collate(Collate.noCase).like('%$searchString%');
              }
              return condition;
            })
            ..orderBy([
              (t) => OrderingTerm(
                  expression: switch (sortField) {
                    ItemFilter.sortingRating => t.rating,
                    ItemFilter.sortingExperienced => t.experienced,
                    ItemFilter.sortingCreatedOn => t.createdOn,
                    ItemFilter.sortingModifiedOn => t.modifiedOn,
                    _ => t.name.collate(Collate.noCase)
                  } as Expression,
                  mode: sortDirection == SortDirection.asc ? OrderingMode.asc : OrderingMode.desc)
            ]))
          .get();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ItemWithTags>> getListerItem(int itemId) async {
    try {
      final item = await (database.select(database.listerItemTable)..where((tbl) => tbl.id.equals(itemId))).getSingle();

      final mappingsQuery = (database.select(database.itemTagMappingTable).join([
        innerJoin(
          database.listerTagTable,
          database.listerTagTable.id.equalsExp(database.itemTagMappingTable.tagId),
        )
      ])
            ..where(database.itemTagMappingTable.itemId.equals(item.id)))
          .get();

      final idToTags = <int, List<ListerTag>>{};

      return mappingsQuery.then((mappings) {
        for (var row in mappings) {
          final item = row.readTable(database.listerTagTable);
          final id = row.readTable(database.itemTagMappingTable).itemId;

          idToTags.putIfAbsent(id, () => []).add(item);
        }

        return Right(ItemWithTags(item, idToTags[item.id] ?? []));
      });
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, List<ItemWithTags>>> getItemsWithTags({
    required int listId,
    String searchString = '',
    required String sortField,
    required SortDirection sortDirection,
  }) async {
    final allItems = await getListerItems(
      listId: listId,
      searchString: searchString,
      sortField: sortField,
      sortDirection: sortDirection,
    );
    final result = allItems.map((items) {
      final Map<int, ListerItem> idToItem = {for (var item in items) item.id: item};
      final ids = idToItem.keys;

      final mappingsQuery = (database.select(database.itemTagMappingTable).join([
        innerJoin(
          database.listerTagTable,
          database.listerTagTable.id.equalsExp(database.itemTagMappingTable.tagId),
        )
      ])
            ..where(database.itemTagMappingTable.itemId.isIn(ids)))
          .get();

      final idToTags = <int, List<ListerTag>>{};

      return mappingsQuery.then((mappings) {
        for (var row in mappings) {
          final item = row.readTable(database.listerTagTable);
          final id = row.readTable(database.itemTagMappingTable).itemId;

          idToTags.putIfAbsent(id, () => []).add(item);
        }

        return <ItemWithTags>[
          for (var id in ids) ItemWithTags(idToItem[id]!, idToTags[id] ?? []),
        ];
      });
    });

    return switch (result) {
      Left(value: var l) => Left(l),
      Right(value: var r) => Right(await r),
      _ => throw TypeError()
    };
  }

  Future<Either<Failure, ListerItem>> findListerItemByName(String name) async {
    try {
      final query = (database.select(database.listerItemTable)
            ..where((tbl) => tbl.name.collate(Collate.noCase).equals(name)))
          .getSingle();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, List<ListerItem>>> getItemsByDates(DateTime from, DateTime to) async {
    try {
      final query =
          (database.select(database.listerItemTable)..where((tbl) => tbl.createdOn.isBetweenValues(from, to))).get();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ItemWithTags>> createItem(
      int listId, String name, String description, int rating, bool experienced, List<ListerTag> tags) async {
    try {
      final DateTime now = DateTime.now();
      return database.transaction(() async {
        final newItem = await database.into(database.listerItemTable).insertReturning(ListerItemTableCompanion.insert(
            listId: listId,
            name: name,
            description: Value(description),
            rating: Value(rating),
            experienced: Value(experienced),
            createdOn: now,
            modifiedOn: now));

        await database.batch((batch) {
          batch.insertAll(
              database.itemTagMappingTable,
              tags.map((tag) => ItemTagMappingTableCompanion.insert(
                    itemId: newItem.id,
                    tagId: tag.id,
                  )));
        });

        return Right(ItemWithTags(newItem, tags));
      });
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ItemWithTags>> updateItem(int itemId,
      {String? name, String? description, int? rating, bool? experienced, List<ListerTag>? tags}) async {
    try {
      final item = (await (database.update(database.listerItemTable)..where((tbl) => tbl.id.equals(itemId)))
              .writeReturning(ListerItemTableCompanion(
                  name: Value.ofNullable(name),
                  description: Value.ofNullable(description),
                  rating: Value.ofNullable(rating),
                  experienced: Value.ofNullable(experienced))))
          .first;

      if (tags != null) {
        await database.batch((batch) {
          // first delete existing entries
          batch.deleteWhere(database.itemTagMappingTable, (e) => e.itemId.equals(itemId));

          // and then insert all entries
          batch.insertAll(
              database.itemTagMappingTable,
              tags.map((tag) => ItemTagMappingTableCompanion.insert(
                    itemId: item.id,
                    tagId: tag.id,
                  )));
        });
      }

      return getListerItem(itemId);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteItem(int itemId) async {
    try {
      // first delete associations
      await database.batch((batch) {
        batch.deleteWhere(database.itemTagMappingTable, (e) => e.itemId.equals(itemId));
      });

      final result = await (database.delete(database.listerItemTable)..where((tbl) => tbl.id.equals(itemId))).go();
      if (result == 1) {
        return Right(result);
      } else {
        return Left(Failure('Could not delete item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  //#endregion Items
  //#region Tags

  Future<Either<Failure, List<ListerTag>>> getTags() async {
    try {
      final query =
          (database.select(database.listerTagTable)..orderBy([(t) => OrderingTerm(expression: t.name)])).get();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerTag>> createTag(String name, Color color) async {
    try {
      final query = database
          .into(database.listerTagTable)
          .insertReturning(ListerTagTableCompanion.insert(name: name, color: color));
      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteTag(int tagId) async {
    try {
      final result = await (database.delete(database.listerTagTable)..where((tbl) => tbl.id.equals(tagId))).go();
      if (result == 1) {
        return Right(result);
      } else {
        return Left(Failure('Could not delete item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

//#endregion Tags
}
