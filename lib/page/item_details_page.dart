import 'package:flutter/material.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/service/persistence_service.dart';

class ItemDetailsPage extends StatefulWidget {
  static const String routeName = "ItemDetailsPage";

  final ListerItem listerItem;

  const ItemDetailsPage(this.listerItem, {Key? key}) : super(key: key);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  late ListerItem listerItem;

  @override
  void initState() {
    super.initState();

    listerItem = widget.listerItem;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(listerItem);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Entry details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                tooltip: 'Delete Item',
                onPressed: () async {
                  final bool decision = await showConfirmationDialog(
                    context,
                    'Delete item',
                    'Are you sure that you want to delete the item "${listerItem.name}"?',
                  );

                  if (decision) {
                    PersistenceService.of(context).deleteItem(listerItem.id!).then((value) {
                      value.fold((l) {
                        showErrorMessage(context, 'Could not delete item!', l.error, l.stackTrace);
                      }, (r) {
                        Navigator.of(context).pop();
                      });
                    });
                  }
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name *'),
                    initialValue: listerItem.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name must not be empty!';
                      }
                    },
                  ),
                  CheckboxListTile(
                      title: const Text("Experienced"),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      value: listerItem.experienced,
                      onChanged: (value) {
                        if (value != null) {
                          PersistenceService.of(context).updateItemExperienced(listerItem, value).then((value) {
                            value.fold((l) {
                              showErrorMessage(context, 'Failed to update item!', l.error, l.stackTrace);
                            }, (r) {
                              setState(() {
                                listerItem = r;
                              });
                            });
                          });
                        }
                      }),
                  DropdownButtonFormField<int>(
                    value: listerItem.rating,
                    decoration: const InputDecoration(labelText: 'Rating'),
                    items: Iterable<int>.generate(11)
                        .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        PersistenceService.of(context).updateItemRating(listerItem, value).then((value) {
                          value.fold((l) {
                            showErrorMessage(context, 'Failed to update item!', l.error, l.stackTrace);
                          }, (r) {
                            setState(() {
                              listerItem = r;
                            });
                          });
                        });
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    initialValue: listerItem.description,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
