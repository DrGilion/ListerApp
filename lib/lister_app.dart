import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/service/import_export_service.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ListerApp extends StatelessWidget {
  final Database database;

  const ListerApp(this.database, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => PersistenceService(database)),
        Provider(create: (context) => ImportExportService()),
        ChangeNotifierProvider(create: (_) => ItemFilter())
      ],
      builder: (context, _) => MaterialApp.router(
        title: 'Lister App',
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
        ],
        theme: ThemeData(primarySwatch: Colors.blue, dividerTheme: const DividerThemeData(space: 0)),
        routerConfig: router,
      ),
    );
  }
}
