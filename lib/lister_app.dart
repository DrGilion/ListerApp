import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/service/import_export_service.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/shortcuts.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:lister_app/viewmodel/top_navigation_data.dart';
import 'package:lister_app/voice_assist/commands.dart';
import 'package:provider/provider.dart';

class ListerApp extends StatefulWidget {
  final ListerDatabase database;

  const ListerApp(this.database, {super.key});

  @override
  State<ListerApp> createState() => _ListerAppState();
}

class _ListerAppState extends State<ListerApp> {
  @override
  void initState() {
    super.initState();

    AppShortcuts.initShortcuts(context);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MultiProvider(
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
            searchBarTheme: SearchBarThemeData(
              shape: MaterialStateProperty.resolveWith((states) =>
                  const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)))),
            ),
            dividerTheme: const DividerThemeData(space: 0),
            useMaterial3: false,
          ),
          routerConfig: router,
        ),
      ),
    );
  }
}
