import 'package:go_router/go_router.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/page/home_page.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/page/item_details_page.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/item/create',
      builder: (context, state) => ItemCreationPage(int.parse(state.queryParameters['listId']!)),
    ),
    GoRoute(
      path: '/item/details',
      builder: (context, state) => ItemDetailsPage(state.extra as ListerItem),
    ),
  ],
);
