import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/page/item_details_page.dart';
import 'package:lister_app/service/persistence_service.dart';

import 'package:lister_app/component/confimation_dialog.dart';

class ListerItemTile extends StatefulWidget {
  final ListerItem listItem;

  const ListerItemTile({Key? key, required this.listItem}) : super(key: key);

  @override
  State<ListerItemTile> createState() => _ListerItemTileState();
}

class _ListerItemTileState extends State<ListerItemTile> {
  static const String optionDelete = 'delete';

  late ListerItem listItem;

  @override
  void initState() {
    super.initState();

    listItem = widget.listItem;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        final RenderBox button = context.findRenderObject()! as RenderBox;
        final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu<String>(
          context: context,
          position: position,
          items: [
            const PopupMenuItem(
              value: optionDelete,
              child: ListTile(leading: Icon(Icons.delete), title: Text('Delete Item')),
            )
          ],
        ).then((value) async {
          switch (value) {
            case optionDelete:
              final bool decision = await showConfirmationDialog(
                context,
                'Delete item',
                'Are you sure that you want to delete the item "${listItem.name}"?',
              );

              if (decision) {
                PersistenceService.of(context).deleteItem(listItem.id!).then((value) {
                  value.fold((l) {
                    showErrorMessage(context, 'Could not delete item!', l.error, l.stackTrace);
                  }, (r) {
                    ItemRemovedNotification(listItem.id!).dispatch(context);
                  });
                });
              }
              break;
          }
        });
      },
      child: ListTile(
        leading: listItem.experienced ? const Icon(Icons.check, color: Colors.green) : const SizedBox(),
        title: Text(listItem.name),
        subtitle: Linkify(text: listItem.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(listItem.rating.toString()),
            const SizedBox(width: 2),
            const Icon(
              Icons.star,
              size: 12,
              color: Colors.grey,
            )
          ],
        ),
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
      ),
    );
  }
}
