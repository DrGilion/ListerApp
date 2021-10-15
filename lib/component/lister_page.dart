import 'package:flutter/material.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/service/persistence_service.dart';

class ListerPage extends StatefulWidget {
  final SimpleListerList list;

  const ListerPage(this.list, {Key? key}) : super(key: key);

  @override
  _ListerPageState createState() => _ListerPageState();
}

class _ListerPageState extends State<ListerPage> {
  ListerList? completeList;

  @override
  void initState() {
    super.initState();

    PersistenceService.of(context).getCompleteList(widget.list.id!).then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve items for list "${widget.list.name}"', l.exception, l.stackTrace);
      }, (r) {
        setState(() {
          completeList = r;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      floatingActionButton: completeList == null
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _tryAddItem(context),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (completeList == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (completeList!.items.isEmpty) {
      return Center(
        child: TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
          onPressed: () => _tryAddItem(context),
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (context, index) => ListerItemTile(completeList!.items[index]),
      separatorBuilder: (_, __) => const Divider(color: Colors.black,),
      itemCount: completeList!.items.length,
    );
  }

  Future<void> _tryAddItem(BuildContext context) async {
    final newItem = await Navigator.of(context).pushNamed(ItemCreationPage.routeName, arguments: widget.list.id);

    if (newItem != null) {
      setState(() {
        completeList!.items.add(newItem as ListerItem);
      });
    }
  }
}
