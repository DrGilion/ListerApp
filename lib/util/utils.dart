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

  static String formatDate(DateTime date){
    return DateFormat().format(date);
  }
}
