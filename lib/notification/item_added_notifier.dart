import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:provider/provider.dart';

class ItemAddedNotifier extends ChangeNotifier {
  static ItemAddedNotifier of(BuildContext context) => Provider.of<ItemAddedNotifier>(context, listen: false);

  ListerItem? item;

  void add(ListerItem newItem) {
   item = newItem;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}