import 'package:flutter/material.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/page/item_creation_page.dart';

class ListerPage extends StatefulWidget {
  final ListerList list;

  const ListerPage(this.list, {Key? key}) : super(key: key);

  @override
  _ListerPageState createState() => _ListerPageState();
}

class _ListerPageState extends State<ListerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) => ListerItemTile(widget.list.items[index]),
        separatorBuilder: (_, __) => Divider(),
        itemCount: widget.list.items.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newItem = await Navigator.of(context).pushNamed(ItemCreationPage.routeName);
        },
      ),
    );
  }
}
