import 'package:lister_app/model/lister_item.dart';

class ListerList{
  int id;
  String title;
  List<ListerItem> items;

  ListerList(this.id, this.title, this.items);
}