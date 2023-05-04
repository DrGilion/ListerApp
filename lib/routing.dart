import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/extensions.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/page/home_page.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/page/item_details_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// GoRouter configuration
final router = GoRouter(
  navigatorKey: navigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/item/create',
      builder: (context, state) => ItemCreationPage(state.queryParameters['listId']?.let(int.parse)),
    ),
    GoRoute(
      path: '/item/details',
      builder: (context, state) => ItemDetailsPage(state.extra as ListerItem),
    ),
  ],
);
