import 'package:drift/drift.dart';
import 'package:lister_app/model/base.dart';
import 'package:lister_app/service/lister_database.dart';

@DataClassName('ListerList')
class ListerListTable extends Table with AutoIncrementingPrimaryKey {
  TextColumn get name => text()();

  IntColumn get color => integer().map(const ColorConverter())();
}
