import 'package:flutter/widgets.dart';

class FlutterUtil {
  FlutterUtil._();

  static void globalUnfocus() {
    WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
  }
}
