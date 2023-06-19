import 'package:drift/drift.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/lister_tag.dart';

@DataClassName('ItemTagMapping')
class ItemTagMappingTable extends Table {
  IntColumn get itemId => integer().references(ListerListTable, #id)();

  IntColumn get tagId => integer().references(ListerTagTable, #id)();
}
