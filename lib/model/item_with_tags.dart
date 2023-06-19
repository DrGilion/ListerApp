import 'package:lister_app/service/lister_database.dart';

class ItemWithTags {
  final ListerItem item;
  final List<ListerTag> tags;

  ItemWithTags(this.item, this.tags);
}