import 'package:flutter/material.dart';
import 'package:lister_app/lister_app.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = await openDatabase(
    join(await getDatabasesPath(), 'lister_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        '''
        CREATE TABLE ${SimpleListerList.tableName} (id INTEGER PRIMARY KEY, name TEXT);
        CREATE TABLE ${ListerItem.tableName} (id INTEGER PRIMARY KEY, 
                                    list_id INTEGER,
                                    name TEXT,
                                    description TEXT,
                                    rating INTEGER,
                                    experienced INTEGER,
                                    created_on INTEGER,
                                    modified_on INTEGER,
                                    FOREIGN KEY (list_id) REFERENCES core_list(id)
        );
        ''',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  runApp(ListerApp(database));
}
