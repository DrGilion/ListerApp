import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/page/item_details_page.dart';

class ListerItemTile extends StatefulWidget {
  final ListerItem listItem;

  const ListerItemTile(this.listItem, {Key? key}) : super(key: key);

  @override
  State<ListerItemTile> createState() => _ListerItemTileState();
}

class _ListerItemTileState extends State<ListerItemTile> {
  late ListerItem listItem;

  @override
  void initState() {
    super.initState();

    listItem = widget.listItem;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: listItem.experienced ? const Icon(Icons.check, color: Colors.green) : const SizedBox(),
      title: Text(listItem.name),
      subtitle: Text(listItem.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Text(listItem.rating.toString()),
      onTap: () async {
        final returnedItem = await Navigator.of(context).pushNamed(ItemDetailsPage.routeName, arguments: listItem);
        if (returnedItem == null) {
          ItemRemovedNotification(listItem.id!).dispatch(context);
        } else {
          setState(() {
            listItem = returnedItem as ListerItem;
          });
        }
      },
    );
  }
}
