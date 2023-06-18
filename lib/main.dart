import 'package:flutter/material.dart';
import 'package:lister_app/lister_app.dart';
import 'package:lister_app/service/lister_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = ListerDatabase();

  runApp(ListerApp(database));
}
