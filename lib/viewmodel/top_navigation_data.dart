import 'package:flutter/material.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/viewmodel/display_mode.dart';
import 'package:provider/provider.dart';

class TopNavigationData extends ChangeNotifier {
  static TopNavigationData of(BuildContext context) => Provider.of<TopNavigationData>(context, listen: false);

  static const nameToModeMap = {
    'Lists': DisplayMode.lists,
    'Calendar': DisplayMode.calendar,
  };

  DisplayMode _displayMode = DisplayMode.lists;

  DisplayMode get displayMode => _displayMode;

  set displayMode(DisplayMode newMode) {
    logger.i('setting top level navigation to $newMode');
    _displayMode = newMode;
    notifyListeners();
  }
}
