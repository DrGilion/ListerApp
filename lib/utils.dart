
class Utils{
  Utils._();

  static DateTime fromMillis(int? millis){
    return DateTime.fromMillisecondsSinceEpoch(millis ?? 0);
  }
}