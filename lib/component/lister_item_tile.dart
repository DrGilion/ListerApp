import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:go_router/go_router.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/popup_options.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/notification/item_removed_notification.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';

class ListerItemTile extends StatefulWidget {
  final ListerItem listItem;
  final String highlightedText;

  const ListerItemTile({super.key, required this.listItem, this.highlightedText = ''});

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
  void didUpdateWidget(covariant ListerItemTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.listItem != widget.listItem) {
      listItem = widget.listItem;
    }
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
            PopupMenuItem(
              value: PopupOptions.delete,
              child: ListTile(leading: const Icon(Icons.delete), title: Text(Translations.of(context).deleteItem)),
            )
          ],
        ).then((value) async {
          switch (value) {
            case PopupOptions.delete:
              final bool decision = await showConfirmationDialog(
                context,
                Translations.of(context).deleteItem,
                Translations.of(context).deleteItem_confirm(listItem.name),
              );

              if (decision && mounted) {
                PersistenceService.of(context).deleteItem(listItem.id).then((value) {
                  value.fold((l) {
                    showErrorMessage(context, Translations.of(context).deleteItem_error, l.error, l.stackTrace);
                  }, (r) {
                    ItemRemovedNotification(listItem.id).dispatch(context);
                  });
                });
              }
              break;
          }
        });
      },
      child: ListTile(
        leading: listItem.experienced
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check, color: Colors.green),
                ],
              )
            : const SizedBox(),
        title: TextHighlight(
          text: listItem.name,
          textStyle: const TextStyle(color: Colors.black),
          words: {
            if (widget.highlightedText.isNotEmpty)
              widget.highlightedText: HighlightedWord(textStyle: const TextStyle(backgroundColor: Colors.yellowAccent))
          },
        ),
        subtitle: Linkify(text: listItem.description, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(listItem.rating.toString()),
            const SizedBox(width: 2),
            const Icon(
              Icons.star,
              size: 12,
              color: Colors.amber,
            )
          ],
        ),
        onTap: () async {
          final returnedItem = await context.push('/item/details', extra: listItem);
          if (returnedItem == null && mounted) {
            ItemRemovedNotification(listItem.id).dispatch(context);
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
