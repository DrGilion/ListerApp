import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/main.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/service/import_export_service.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:lister_app/viewmodel/top_navigation_data.dart';
import 'package:lister_app/voice_assist/commands.dart';
import 'package:provider/provider.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:sqflite/sqflite.dart';

class ListerApp extends StatefulWidget {
  final Database database;

  const ListerApp(this.database, {super.key});

  @override
  State<ListerApp> createState() => _ListerAppState();
}

class _ListerAppState extends State<ListerApp> {
  @override
  void initState() {
    super.initState();

    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case 'add_item':
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentContext
                ?.push<ListerItem>(Uri(path: '/item/create').toString())
                .then((ListerItem? newItem) {
              if (newItem != null) {
                ItemAddedNotifier.of(navigatorKey.currentContext!).add(newItem);
              }
            });
          });
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(
        type: 'add_item',
        localizedTitle: 'Add item',
        icon: Platform.isAndroid ? 'ic_launcher' : 'AppIcon',
      ),
    ]).then((void _) {
      logger.i('shortcuts enabled!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => PersistenceService(widget.database)),
        Provider(create: (context) => ImportExportService()),
        ChangeNotifierProvider(create: (context) => Commands()),
        ChangeNotifierProvider(create: (_) => ItemFilter()),
        ChangeNotifierProvider(create: (_) => ItemAddedNotifier()),
        ChangeNotifierProvider(create: (_) => TopNavigationData()),
        ChangeNotifierProvider(create: (_) => ListNavigationData()),
      ],
      builder: (context, _) => MaterialApp.router(
        title: 'Lister App',
        localizationsDelegates: const [
          Translations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: Translations.delegate.supportedLocales,
        theme: ThemeData(
          dividerTheme: const DividerThemeData(space: 0),
        ),
        routerConfig: router,
      ),
    );
  }
}
