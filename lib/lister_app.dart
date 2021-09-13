import 'package:flutter/material.dart';
import 'package:lister_app/page/home_page.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/service/import_export_service.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:provider/provider.dart';

class ListerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => PersistenceService()),
        Provider(create: (context) => ImportExportService()),
      ],
      builder: (context, _) =>  MaterialApp(
        title: 'Lister App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (_) => HomePage(),
          ItemCreationPage.routeName: (_) => ItemCreationPage()
        },
      ),
    );
  }
}
