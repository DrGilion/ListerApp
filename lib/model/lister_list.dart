import 'package:lister_app/model/lister_item.dart';

class ListerList {
  int id;
  String name;
  int color;
  List<ListerItem> items;

  ListerList(this.id, this.name, this.color, this.items);
}
