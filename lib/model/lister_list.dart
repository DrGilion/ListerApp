import 'package:lister_app/model/lister_item.dart';

class ListerList{
  int id;
  String name;
  List<ListerItem> items;

  ListerList(this.id, this.name, this.items);
}