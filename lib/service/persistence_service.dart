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
    } catch (e) {
      return Left(Failure());
    }
  }

  Future<ListerList> getCompleteList(int listId) async {
    final Map<String, Object?> result =
        (await database.query(SimpleListerList.tableName, where: 'id = ?', whereArgs: [listId])).first;
    final theList = SimpleListerList.fromJson(result);

    final List<Map<String, dynamic>> itemResults =
        await database.query(ListerItem.tableName, where: 'list_id = ?', whereArgs: [listId]);
    final items = itemResults.map((e) => ListerItem.fromJson(e)).toList();

    return ListerList(theList.id!, theList.name, items);
  }

  Future<SimpleListerList> createList(String name) async {
    final newList = SimpleListerList(null, name);
    newList.id = await database.insert(SimpleListerList.tableName, newList.toJson());
    return newList;
  }

  Future<int> renameList(int listId, String newName) async {
    return database.update(SimpleListerList.tableName, SimpleListerList(listId, newName).toJson(),
        where: 'id = ?', whereArgs: [listId]);
  }

  Future<int> deleteList(int listId) async {
    return database.delete(SimpleListerList.tableName, where: 'id = ?', whereArgs: [listId]);
  }

  int _getNextItemId() {
    //TODO
    return 0;
  }

  Future<ListerItem> createItem(int listId, String name, String description, int rating, bool experienced) async {
    final DateTime now = DateTime.now();
    final newItem = ListerItem(null, listId, name, description, rating, experienced, now, now);
    newItem.id = await database.insert(ListerItem.tableName, newItem.toJson());
    return newItem;
  }

  ListerItem updateItemName(int itemId, String name) {
    return ListerItem(_getNextItemId(), 0, '', '', 0, false, DateTime.now(), DateTime.now());
  }

  ListerItem updateItemDescription(int itemId, String description) {
    return ListerItem(_getNextItemId(), 0, '', '', 0, false, DateTime.now(), DateTime.now());
  }

  ListerItem updateItemRating(int itemId, int rating) {
    return ListerItem(_getNextItemId(), 0, '', '', 0, false, DateTime.now(), DateTime.now());
  }

  ListerItem updateItemExperienced(int itemId, bool experienced) {
    return ListerItem(_getNextItemId(), 0, '', '', 0, false, DateTime.now(), DateTime.now());
  }

  void deleteItem(int itemId) {}
}
