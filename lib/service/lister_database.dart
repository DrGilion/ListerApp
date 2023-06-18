import 'dart:io';
import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/lister_tag.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

export 'dart:ui' show Color;

part 'lister_database.g.dart';

@DriftDatabase(tables: [ListerListTable, ListerItemTable, ListerTagTable])
class ListerDatabase extends _$ListerDatabase {
  // we tell the database where to store the data with this constructor
  ListerDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

class ColorConverter extends TypeConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromSql(int fromDb) => Color(fromDb);

  @override
  int toSql(Color value) => value.value;
}
