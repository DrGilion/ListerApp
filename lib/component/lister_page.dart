import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_item_tile.dart';
import 'package:lister_app/component/sort_button.dart';
import 'package:lister_app/filter/item_filter.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/delayed_callback.dart';

class ListerPage extends StatefulWidget {
  final ListerList list;

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

  List<ListerItem>? _items;

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
                ItemFilter.sortingName: Tuple2(FontAwesomeIcons.font, Translations.of(context).name),
                ItemFilter.sortingRating: Tuple2(FontAwesomeIcons.star, Translations.of(context).rating),
                ItemFilter.sortingExperienced: Tuple2(FontAwesomeIcons.check, Translations.of(context).experienced),
                ItemFilter.sortingCreatedOn: Tuple2(FontAwesomeIcons.calendar, Translations.of(context).createdOn),
                ItemFilter.sortingModifiedOn: Tuple2(FontAwesomeIcons.calendar, Translations.of(context).modifiedOn),
              },
            )
          ],
          hintText: MaterialLocalizations.of(context).searchFieldLabel,
        ),
      ),
      floatingActionButton: _items == null
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _tryAddItem(context),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_items == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items!.isEmpty) {
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
          _items!.removeWhere((element) => element.id == notification.itemId);
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
            key: ValueKey(_items![index].id),
            listItem: _items![index],
            highlightedText: searchTextController.text,
          ),
          separatorBuilder: (_, __) => const Divider(
            color: Colors.black,
          ),
          itemCount: _items!.length,
        ),
      ),
    );
  }

  Future<void> _fetchList(BuildContext context) {
    return PersistenceService.of(context)
        .getListerItems(listId: widget.list.id,
            searchString: searchTextController.text,
            sortField: _filter.sorting.value1,
            sortDirection: _filter.sorting.value2)
        .then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).getItems_error(widget.list.name), l.error, l.stackTrace);
      }, (r) {
        setState(() {
          _items = r;
        });
      });
    });
  }

  Future<void> _tryAddItem(BuildContext context) async {
    final ListerItem? newItem = await context
        .push<ListerItem>(Uri(path: '/item/create', queryParameters: {'listId': widget.list.id.toString()}).toString());

    if (newItem != null) {
      setState(() {
        _items!.add(newItem);
      });
    }
  }
}
