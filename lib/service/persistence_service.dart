import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';
import 'package:lister_app/model/failure.dart';
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

  Future<Either<Failure, ListerList>> updateList(ListerList listerList, {String? newName, Color? newColor}) async {
    try {
      final query = (database.update(database.listerListTable)..where((tbl) => tbl.id.equals(listerList.id)))
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

  Future<Either<Failure, ListerItem>> getListerItem(int itemId) async {
    try {
      final query = (database.select(database.listerItemTable)..where((tbl) => tbl.id.equals(itemId))).getSingle();

      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
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

  Future<Either<Failure, ListerItem>> createItem(
      int listId, String name, String description, int rating, bool experienced) async {
    try {
      final DateTime now = DateTime.now();
      final query = database.into(database.listerItemTable).insertReturning(ListerItemTableCompanion.insert(
          listId: listId,
          name: name,
          description: Value(description),
          rating: Value(rating),
          experienced: Value(experienced),
          createdOn: now,
          modifiedOn: now));
      print(await query);
      return Right(await query);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerItem>> updateItem(ListerItem item,
      {String? name, String? description, int? rating, bool? experienced}) async {
    try {
      final query = (database.update(database.listerItemTable)..where((tbl) => tbl.id.equals(item.id))).writeReturning(
          ListerItemTableCompanion(
              name: Value.ofNullable(name),
              description: Value.ofNullable(description),
              rating: Value.ofNullable(rating),
              experienced: Value.ofNullable(experienced)));

      return Right((await query).first);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteItem(int itemId) async {
    try {
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
