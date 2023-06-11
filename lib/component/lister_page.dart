import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/component/sort_button.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/model/lister_list.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/delayed_callback.dart';

class ListerPage extends StatefulWidget {
  final SimpleListerList list;

  const ListerPage(this.list, {super.key});

  @override
  State<ListerPage> createState() => _ListerPageState();
}

class _ListerPageState extends State<ListerPage> {
  TextEditingController searchTextController = TextEditingController();
  late VoidCallback searchListener;
  late ItemFilter _filter;
  late Function() _filterListener;
  late ItemAddedNotifier _itemAddedNotifier;
  late Function() _itemAddedListener;

  ListerList? completeList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _filter = ItemFilter.of(context);
    _fetchList(context);
    _filter.addListener(_filterListener = () {
      _fetchList(context);
    });
    _itemAddedNotifier = ItemAddedNotifier.of(context);
    _itemAddedNotifier.addListener(_itemAddedListener = () {
      if (_itemAddedNotifier.item?.listId == widget.list.id) {
        _fetchList(context);
      }
    });

    searchTextController.addListener(searchListener = () {
      DelayedCallback().run(() {
        _fetchList(context);
      });
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchTextController.removeListener(searchListener);
    searchTextController.dispose();

    _filter.removeListener(_filterListener);
    _itemAddedNotifier.removeListener(_itemAddedListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: SearchBar(
          controller: searchTextController,
          leading: const Icon(Icons.search),
          trailing: [
            SortButton(
              filter: _filter,
              optionsMap: {
                'name': Tuple2(FontAwesomeIcons.font, Translations.of(context).name),
                'rating': Tuple2(FontAwesomeIcons.star, Translations.of(context).rating),
                'experienced': Tuple2(FontAwesomeIcons.check, Translations.of(context).experienced),
                'created_on': Tuple2(FontAwesomeIcons.calendar, Translations.of(context).createdOn),
                'modified_on': Tuple2(FontAwesomeIcons.calendar, Translations.of(context).modifiedOn),
              },
            )
          ],
          hintText: MaterialLocalizations.of(context).searchFieldLabel,
        ),
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
          label: Text(Translations.of(context).addItem),
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
      child: RefreshIndicator(
        onRefresh: () async {
          await _fetchList(context);
        },
        child: ListView.separated(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(bottom: kToolbarHeight),
          itemBuilder: (context, index) => ListerItemTile(
            key: ValueKey(completeList!.items[index].id),
            listItem: completeList!.items[index],
            highlightedText: searchTextController.text,
          ),
          separatorBuilder: (_, __) => const Divider(
            color: Colors.black,
          ),
          itemCount: completeList!.items.length,
        ),
      ),
    );
  }

  Future<void> _fetchList(BuildContext context) {
    return PersistenceService.of(context)
        .getCompleteList(widget.list.id!,
            searchString: searchTextController.text,
            sortField: _filter.sorting.value1,
            sortDirection: _filter.sorting.value2)
        .then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).getItems_error(widget.list.name), l.error, l.stackTrace);
      }, (r) {
        setState(() {
          completeList = r;
        });
      });
    });
  }

  Future<void> _tryAddItem(BuildContext context) async {
    final ListerItem? newItem = await context
        .push<ListerItem>(Uri(path: '/item/create', queryParameters: {'listId': widget.list.id.toString()}).toString());

    if (newItem != null) {
      setState(() {
        completeList!.items.add(newItem);
      });
    }
  }
}
