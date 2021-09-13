import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:provider/provider.dart';

class PersistenceService {
  static PersistenceService of(BuildContext context) => Provider.of<PersistenceService>(context, listen: false);

  int _getNextItemId(){
    //TODO
    return 0;
  }

  ListerItem createItem(int listId, String name, String description, int rating, bool experienced) {
    final DateTime now = DateTime.now();
    return ListerItem(_getNextItemId(), listId, name, description, rating, experienced, now, now);
  }
}
