import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/util/logging.dart';
import 'package:quick_actions/quick_actions.dart';

/// utility class managing shortcuts (visible by long tapping App)
class AppShortcuts {
  AppShortcuts._();

  static const typeAddItem = 'add_item';

  /// initializes all shortcuts
  static void initShortcuts(BuildContext context) {
    const QuickActions quickActions = QuickActions();
    quickActions.initialize((String shortcutType) {
      switch (shortcutType) {
        case typeAddItem:
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      quickActions.setShortcutItems(<ShortcutItem>[
        ShortcutItem(
          type: typeAddItem,
          localizedTitle: Translations.current.addItem,
          icon: Platform.isAndroid ? 'ic_launcher' : 'AppIcon',
        ),
      ]).then((void _) {
        logger.i('shortcuts enabled!');
      });
    });
  }
}
