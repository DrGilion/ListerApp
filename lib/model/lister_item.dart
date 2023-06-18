import 'package:drift/drift.dart';
import 'package:lister_app/model/base.dart';
import 'package:lister_app/model/lister_list.dart';

@DataClassName('ListerItem')
class ListerItemTable extends Table with AutoIncrementingPrimaryKey {
  IntColumn get listId => integer().references(ListerListTable, #id)();

  TextColumn get name => text()();

  TextColumn get description => text().withDefault(const Constant(''))();

  IntColumn get rating => integer().withDefault(const Constant(0))();

  BoolColumn get experienced => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdOn => dateTime()();

  DateTimeColumn get modifiedOn => dateTime()();
}
