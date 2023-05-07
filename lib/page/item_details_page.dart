import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linkify/linkify.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/text_to_textfield.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/utils.dart';

class ItemDetailsPage extends StatefulWidget {
  static const String routeName = "ItemDetailsPage";

  final ListerItem? listerItem;
  final int? itemId;

  const ItemDetailsPage({this.listerItem, this.itemId, super.key}) : assert(listerItem != null || itemId != null);

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  ListerItem? listerItem;

  @override
  void initState() {
    super.initState();

    if (widget.listerItem != null) {
      listerItem = widget.listerItem!;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        PersistenceService.of(context).getListerItem(widget.itemId!).then((value) {
          value.fold((l) => null, (r) => setState(() => listerItem = r));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return listerItem == null
        ? const SizedBox()
        : SafeArea(
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
                          'Are you sure that you want to delete the item "${listerItem!.name}"?',
                        );

                        if (decision && mounted) {
                          PersistenceService.of(context).deleteItem(listerItem!.id!).then((value) {
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
                        TextToTextField(
                          label: 'Name',
                          initialText: listerItem!.name,
                          onSave: (text) async {
                            if (text.isEmpty) {
                              showErrorMessage(context, 'Name must not be empty!', ArgumentError('Name is empty!'),
                                  StackTrace.current);
                              return false;
                            }

                            final newItem = await PersistenceService.of(context).updateItemName(listerItem!, text);

                            return newItem.fold((l) {
                              showErrorMessage(context, 'Failed to update item!', l.error, l.stackTrace);
                              return false;
                            }, (r) {
                              setState(() {
                                listerItem = r;
                              });
                              return true;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        CheckboxListTile(
                            title: const Text("Experienced"),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            value: listerItem!.experienced,
                            onChanged: (value) {
                              if (value != null) {
                                PersistenceService.of(context).updateItemExperienced(listerItem!, value).then((value) {
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
                        const SizedBox(height: 10),
                        InputDecorator(
                          decoration: const InputDecoration(labelText: 'Rating', border: InputBorder.none),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: RatingBar.builder(
                              initialRating: listerItem!.rating.toDouble(),
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: false,
                              itemCount: 10,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                PersistenceService.of(context)
                                    .updateItemRating(listerItem!, rating.toInt())
                                    .then((value) {
                                  value.fold((l) {
                                    showErrorMessage(context, 'Failed to update item!', l.error, l.stackTrace);
                                  }, (r) {
                                    setState(() {
                                      listerItem = r;
                                    });
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...(linkify(listerItem!.description).whereType<UrlElement>().map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnyLinkPreview(
                                link: e.url,
                                displayDirection: UIDirection.uiDirectionHorizontal,
                                showMultimedia: true,
                                bodyMaxLines: 3,
                                previewHeight: 105,
                                bodyTextOverflow: TextOverflow.ellipsis,
                                titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                                errorBody: e.url,
                                errorTitle: e.url,
                                errorWidget: Container(
                                  color: Colors.grey[300],
                                  child: Text('No preview available for ${e.url}!'),
                                ),
                                cache: const Duration(days: 7),
                                backgroundColor: Colors.grey[300],
                                borderRadius: 16,
                                boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
                              ),
                            ))),
                        const SizedBox(height: 10),
                        TextToTextField(
                          label: 'Description',
                          initialText: listerItem!.description,
                          bigbox: true,
                          onSave: (text) async {
                            final newItem =
                                await PersistenceService.of(context).updateItemDescription(listerItem!, text);

                            return newItem.fold((l) {
                              showErrorMessage(context, 'Failed to update item!', l.error, l.stackTrace);
                              return false;
                            }, (r) {
                              setState(() {
                                listerItem = r;
                              });
                              return true;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Created on: ${Utils.formatDate(listerItem!.createdOn)}')),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Modified on: ${Utils.formatDate(listerItem!.modifiedOn)}')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
