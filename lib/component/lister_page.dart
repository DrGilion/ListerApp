import 'package:flutter/material.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/component/search_bar.dart';
import 'package:lister_app/component/sort_button.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/page/item_creation_page.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:provider/provider.dart';

class ListerPage extends StatefulWidget {
  final SimpleListerList list;

  const ListerPage(this.list, {Key? key}) : super(key: key);

  @override
  _ListerPageState createState() => _ListerPageState();
}

class _ListerPageState extends State<ListerPage> {
  String? searchString;
  late ItemFilter _filter;
  late Function() _filterListener;

  ListerList? completeList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _filter = ItemFilter.of(context);
    _fetchList(context);
    _filter.addListener(_filterListener = () {
      _fetchList(context);
    });
  }

  @override
  void dispose() {
    _filter.removeListener(_filterListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: SearchBar(
          onTextChange: (text) {
            if (text != searchString) {
              searchString = text;

              _fetchList(context);
            }
          },
          initialText: searchString,
        ),
        actions: [
          SortButton(
            filter: _filter,
            optionsMap: const {
              'name': 'Name',
              'rating': 'Rating',
              'experienced': 'Done/ Not Done',
              'modified_on': 'Modification time'
            },
          )
        ],
      ),
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

    return NotificationListener<ItemRemovedNotification>(
      onNotification: (notification) {
        setState(() {
          completeList!.items.removeWhere((element) => element.id == notification.itemId);
        });
        return false;
      },
      child: ListView.separated(
        itemBuilder: (context, index) =>
            ListerItemTile(key: ValueKey(completeList!.items[index].id), listItem: completeList!.items[index]),
        separatorBuilder: (_, __) => const Divider(
          color: Colors.black,
        ),
        itemCount: completeList!.items.length,
      ),
    );
  }

  void _fetchList(BuildContext context) {
    PersistenceService.of(context)
        .getCompleteList(widget.list.id!,
            searchString: searchString ?? '', sortField: _filter.sorting.value1, sortDirection: _filter.sorting.value2)
        .then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve items for list "${widget.list.name}"', l.error, l.stackTrace);
      }, (r) {
        setState(() {
          completeList = r;
        });
      });
    });
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
