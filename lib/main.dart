import 'package:flutter/material.dart';
import 'package:lister_app/lister_app.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final logger = Logger();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init database
  int migrationScriptCount = migrationScripts.length;
  final database = await openDatabase(
    join(await getDatabasesPath(), 'lister_database.db'),
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: migrationScriptCount,
    onCreate: (db, version) async {
      for (int i = 1; i <= migrationScriptCount; i++) {
        logger.i('Executing Script for migration version $i:\n ${migrationScripts[i]!}');
        await db.execute(migrationScripts[i]!);
      }
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      for (int i = oldVersion + 1; i <= newVersion; i++) {
        logger.i('Executing Script for migration version $i:\n ${migrationScripts[i]!}');
        await db.execute(migrationScripts[i]!);
      }
    },
  );

  runApp(ListerApp(database));
}

const Map<int, String> migrationScripts = {
  1: '''
        CREATE TABLE core_list (id INTEGER PRIMARY KEY, name TEXT, color INTEGER);
        ''',
  2: '''
        CREATE TABLE core_list_item (id INTEGER PRIMARY KEY, 
                                    list_id INTEGER,
                                    name TEXT,
                                    description TEXT,
                                    rating INTEGER,
                                    experienced INTEGER,
                                    created_on INTEGER,
                                    modified_on INTEGER,
                                    FOREIGN KEY (list_id) REFERENCES core_list(id)
        );'''
};
