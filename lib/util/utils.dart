import 'dart:ui';

import 'package:intl/intl.dart';

class Utils {
  Utils._();

  static DateTime dateFromMillis(int? millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis ?? 0);
  }

  static int dateToMillis(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  static int boolToInt(bool value) {
    return value ? 1 : 0;
  }

  static bool intToBool(int value) {
    return value == 1;
  }

  static String formatDate(DateTime date) {
    return DateFormat().format(date);
  }

  static Color getContrastingColor(Color color) {
    int d = 0;

    // Counting the perceptive luminance - human eye favors green color...
    double luminance = (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue) / 255;

    d = luminance > 0.5 ? 0 : 255; // dark colors - white font

    return Color.fromARGB(color.alpha, d, d, d);
  }
}
