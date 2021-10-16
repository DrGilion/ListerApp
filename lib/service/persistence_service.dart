import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/model/failure.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class PersistenceService {
  static PersistenceService of(BuildContext context) => Provider.of<PersistenceService>(context, listen: false);

  final Database database;

  PersistenceService(this.database);

  Future<Either<Failure, List<SimpleListerList>>> getListsSimple() async {
    try {
      final List<Map<String, dynamic>> results = await database.query(SimpleListerList.tableName);
      return Right(results.map((e) => SimpleListerList.fromJson(e)).toList());
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerList>> getCompleteList(int listId) async {
    try {
      final Map<String, Object?> result =
          (await database.query(SimpleListerList.tableName, where: 'id = ?', whereArgs: [listId])).first;
      final theList = SimpleListerList.fromJson(result);

      final List<Map<String, dynamic>> itemResults =
          await database.query(ListerItem.tableName, where: 'list_id = ?', whereArgs: [listId]);
      final items = itemResults.map((e) => ListerItem.fromJson(e)).toList();

      return Right(ListerList(theList.id!, theList.name, items));
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, SimpleListerList>> createList(String name) async {
    try {
      final newList = SimpleListerList(null, name);
      newList.id = await database.insert(SimpleListerList.tableName, newList.toJson());
      return Right(newList);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> renameList(int listId, String newName) async {
    try {
      final int rowsAffected = await database.update(
          SimpleListerList.tableName, SimpleListerList(listId, newName).toJson(),
          where: 'id = ?', whereArgs: [listId]);

      return Right(rowsAffected);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteList(int listId) async {
    try {
      final int itemsDeleted = await database.delete(ListerItem.tableName, where: 'list_id = ?', whereArgs: [listId]);
      final int listsDeleted = await database.delete(SimpleListerList.tableName, where: 'id = ?', whereArgs: [listId]);
      if (listsDeleted == 1) {
        return Right(itemsDeleted);
      } else {
        return Left(Failure('No lists deleted', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  int _getNextItemId() {
    //TODO
    return 0;
  }

  Future<Either<Failure, ListerItem>> createItem(
      int listId, String name, String description, int rating, bool experienced) async {
    try {
      final DateTime now = DateTime.now();
      final newItem = ListerItem(null, listId, name, description, rating, experienced, now, now);
      newItem.id = await database.insert(ListerItem.tableName, newItem.toJson());
      return Right(newItem);
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerItem>> updateItemName(ListerItem item, String name) async {
    try {
      final updatedItem = ListerItem(
          item.id, item.listId, name, item.description, item.rating, item.experienced, item.createdOn, DateTime.now());
      final int rowsAffected =
          await database.update(ListerItem.tableName, updatedItem.toJson(), where: 'id = ?', whereArgs: [item.id]);

      if (rowsAffected == 1) {
        return Right(updatedItem);
      } else {
        return Left(Failure('Failed to update item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerItem>> updateItemDescription(ListerItem item, String description) async {
    try {
      final updatedItem = ListerItem(
          item.id, item.listId, item.name, description, item.rating, item.experienced, item.createdOn, DateTime.now());
      final int rowsAffected =
          await database.update(ListerItem.tableName, updatedItem.toJson(), where: 'id = ?', whereArgs: [item.id]);

      if (rowsAffected == 1) {
        return Right(updatedItem);
      } else {
        return Left(Failure('Failed to update item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerItem>> updateItemRating(ListerItem item, int rating) async {
    try {
      final updatedItem = ListerItem(
          item.id, item.listId, item.name, item.description, rating, item.experienced, item.createdOn, DateTime.now());
      final int rowsAffected =
          await database.update(ListerItem.tableName, updatedItem.toJson(), where: 'id = ?', whereArgs: [item.id]);

      if (rowsAffected == 1) {
        return Right(updatedItem);
      } else {
        return Left(Failure('Failed to update item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, ListerItem>> updateItemExperienced(ListerItem item, bool experienced) async {
    try {
      final updatedItem = ListerItem(
          item.id, item.listId, item.name, item.description, item.rating, experienced, item.createdOn, DateTime.now());
      final int rowsAffected =
          await database.update(ListerItem.tableName, updatedItem.toJson(), where: 'id = ?', whereArgs: [item.id]);

      if (rowsAffected == 1) {
        return Right(updatedItem);
      } else {
        return Left(Failure('Failed to update item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }

  Future<Either<Failure, int>> deleteItem(int itemId) async {
    try {
      final int itemsDeleted = await database.delete(ListerItem.tableName, where: 'id = ?', whereArgs: [itemId]);
      if (itemsDeleted == 1) {
        return Right(itemsDeleted);
      } else {
        return Left(Failure('Could not delete item', StackTrace.current));
      }
    } catch (e, stack) {
      return Left(Failure(e, stack));
    }
  }
}
