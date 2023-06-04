import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:linkify/linkify.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/paged_url_preview.dart';
import 'package:lister_app/component/text_to_textfield.dart';
import 'package:lister_app/generated/l10n.dart';
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
                  title: Text(Translations.of(context).details),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: Translations.of(context).deleteItem,
                      onPressed: () async {
                        final bool decision = await showConfirmationDialog(
                          context,
                          Translations.of(context).deleteItem,
                          Translations.of(context).deleteItem_confirm(listerItem!.name),
                        );

                        if (decision && mounted) {
                          PersistenceService.of(context).deleteItem(listerItem!.id!).then((value) {
                            value.fold((l) {
                              showErrorMessage(context, Translations.of(context).deleteItem_confirm(listerItem!.name),
                                  l.error, l.stackTrace);
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
                          label: Translations.of(context).name,
                          initialText: listerItem!.name,
                          onSave: (text) async {
                            if (text.isEmpty) {
                              showErrorMessage(context, Translations.of(context).validation_empty,
                                  ArgumentError('Name is empty!'), StackTrace.current);
                              return false;
                            }

                            final newItem = await PersistenceService.of(context).updateItemName(listerItem!, text);

                            return newItem.fold((l) {
                              showErrorMessage(
                                  context, Translations.of(context).updateItem_error, l.error, l.stackTrace);
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
                            title: Text(Translations.of(context).experienced),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            value: listerItem!.experienced,
                            onChanged: (value) {
                              if (value != null) {
                                PersistenceService.of(context).updateItemExperienced(listerItem!, value).then((value) {
                                  value.fold((l) {
                                    showErrorMessage(
                                        context, Translations.of(context).updateItem_error, l.error, l.stackTrace);
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
                          decoration:
                              InputDecoration(labelText: Translations.of(context).rating, border: InputBorder.none),
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
                                    showErrorMessage(
                                        context, Translations.of(context).updateItem_error, l.error, l.stackTrace);
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
                        PagedUrlPreview(
                            urls:
                                (linkify(listerItem!.description).whereType<UrlElement>().map((e) => e.url).toList())),
                        const SizedBox(height: 10),
                        TextToTextField(
                          label: Translations.of(context).description,
                          initialText: listerItem!.description,
                          bigbox: true,
                          onSave: (text) async {
                            final newItem =
                                await PersistenceService.of(context).updateItemDescription(listerItem!, text);

                            return newItem.fold((l) {
                              showErrorMessage(
                                  context, Translations.of(context).updateItem_error, l.error, l.stackTrace);
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
                            child: Text(
                                '${Translations.of(context).createdOn}: ${Utils.formatDate(listerItem!.createdOn)}')),
                        const SizedBox(height: 10),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${Translations.of(context).modifiedOn}: ${Utils.formatDate(listerItem!.modifiedOn)}')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
