import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/page/home_page.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/page/item_details_page.dart';
import 'package:lister_app/page/settings_page.dart';
import 'package:lister_app/util/extensions.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/item/create',
      builder: (context, state) => ItemCreationPage(state.queryParameters['listId']?.let(int.parse)),
    ),
    GoRoute(
      path: '/item/details',
      builder: (context, state) => ItemDetailsPage(listerItem: state.extra as ListerItem),
    ),
    GoRoute(
      path: '/item/:itemId',
      builder: (context, state) {
        return ItemDetailsPage(itemId: int.parse(state.pathParameters['itemId']!));
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) {
        return const SettingsPage();
      },
    ),
  ],
);
