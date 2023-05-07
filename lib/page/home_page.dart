import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/component/calendar_tab.dart';
import 'package:lister_app/component/lists_tab.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

enum DisplayMode {
  lists,
  calendar;
}

class _HomePageState extends State<HomePage> {
  DisplayMode displayMode = DisplayMode.lists;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: _buildBody(context),
            bottomNavigationBar: ConvexAppBar(
              items: const [
                TabItem(icon: Icons.home, title: 'Lists'),
                TabItem(icon: Icons.calendar_month, title: 'Calendar')
              ],
              onTap: (int index) {
                setState(() {
                  displayMode = index == 0 ? DisplayMode.lists : DisplayMode.calendar;
                });
              },
            )));
  }

  Widget _buildBody(BuildContext context) {
    switch (displayMode) {
      case DisplayMode.lists:
        return const ListsTab();
      case DisplayMode.calendar:
        return const CalendarTab();
    }
  }
}
