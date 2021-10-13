import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/page/home_page.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/page/item_details_page.dart';
import 'package:lister_app/service/import_export_service.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

class ListerApp extends StatelessWidget {
  final Database database;

  ListerApp(this.database);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => PersistenceService(database)),
        Provider(create: (context) => ImportExportService()),
      ],
      builder: (context, _) => MaterialApp(
          title: 'Lister App',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
          ],
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          initialRoute: HomePage.routeName,
          onGenerateRoute: (RouteSettings settings) {
            late Widget route;

            switch (settings.name) {
              case HomePage.routeName:
                route = HomePage();
                break;
              case ItemCreationPage.routeName:
                route = ItemCreationPage(settings.arguments as int);
                break;
              case ItemDetailsPage.routeName:
                route = ItemDetailsPage(settings.arguments as ListerItem);
                break;
            }

            return MaterialPageRoute(
              builder: (context) {
                return route;
              },
            );
          }),
    );
  }
}
