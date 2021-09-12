import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  List<ListTab> tabs = [
    ListTab(icon: Icons.home, title: 'Home', widget: Container(color: Colors.red,)),
    ListTab(icon: Icons.map, title: 'Discovery', widget: Container()),
    ListTab(icon: Icons.add, title: 'Add', widget: Container()),
    ListTab(icon: Icons.message, title: 'Message', widget: Container()),
    ListTab(icon: Icons.people, title: 'Profile', widget: Container()),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Lister'),),
        body: tabs[currentIndex].widget,
          bottomNavigationBar: ConvexAppBar(
            items: tabs.map((e) => TabItem(icon: e.icon, title: e.title)).toList(),
            initialActiveIndex: currentIndex,
            onTap: (int i) {
              setState(() {
                currentIndex = i;
              });
            },
          )
      ),
    );
  }
}

class ListTab{
  final IconData icon;
  final String title;
  final Widget widget;

  ListTab({required this.icon, required this.title, required this.widget});
}
