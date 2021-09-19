import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:provider/provider.dart';

class PersistenceService {
  static PersistenceService of(BuildContext context) => Provider.of<PersistenceService>(context, listen: false);

  List<SimpleListerList> getListsSimple(){
    return [SimpleListerList(0, 'A'),SimpleListerList(1, 'B')];
  }

  ListerList getList(int listId){
    return ListerList(0, 'title', []);
  }

  SimpleListerList createList(String name){
    return SimpleListerList(0, name);
  }

  ListerList renameList(int listId, String newName){
    return ListerList(0, 'title', []);
  }

  void deleteList(int listId){

  }

  int _getNextItemId(){
    //TODO
    return 0;
  }

  ListerItem createItem(int listId, String name, String description, int rating, bool experienced) {
    final DateTime now = DateTime.now();
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }

  ListerItem updateItemName(int itemId, String name) {
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }

  ListerItem updateItemDescription(int itemId, String description) {
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }

  ListerItem updateItemRating(int itemId, int rating) {
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }

  ListerItem updateItemExperienced(int itemId, bool experienced) {
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }

  void deleteItem(int itemId) {

  }
}
