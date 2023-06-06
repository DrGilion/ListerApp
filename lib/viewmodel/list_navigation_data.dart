import 'package:flutter/material.dart';
import 'package:lister_app/util/logging.dart';
import 'package:provider/provider.dart';

class ListNavigationData extends ChangeNotifier {
  static ListNavigationData of(BuildContext context) => Provider.of<ListNavigationData>(context, listen: false);

  int? _currentListId;

  int? get currentListId => _currentListId;

  set currentListId(int? listId) {
    logger.i('setting list id $listId');
    _currentListId = listId;
    notifyListeners();
  }
}
