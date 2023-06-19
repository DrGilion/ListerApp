import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/save_loading_button.dart';
import 'package:lister_app/component/tag_item.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';

class ItemCreationPage extends StatefulWidget {
  static const String routeName = "ItemCreationPage";

  final int? initialListId;

  const ItemCreationPage(this.initialListId, {super.key});

  @override
  State<ItemCreationPage> createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  int? listId;
  String? name;
  String description = '';
  bool experienced = false;
  int rating = 0;
  List<ListerTag> tags = [];

  final GlobalKey<FormState> formKey = GlobalKey();
  final _textEditingController = TextEditingController();
  bool isSaving = false;

  final InputDecoration inputDecoration = const InputDecoration();

  List<ListerList> availableLists = [];
  List<ListerTag> availableTags = [];

  @override
  void initState() {
    super.initState();

    listId = widget.initialListId;

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).lists_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          availableLists = r;
        });
      });
    });

    PersistenceService.of(context).getTags().then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).tags_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          availableTags = r;
        });
      });
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Translations.of(context).addItem),
          actions: [
            SaveLoadingButton(
              isSaving: isSaving,
              onPressed: () => _trySave(context),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<int>(
                    value: listId,
                    decoration: inputDecoration.copyWith(labelText: '${Translations.of(context).list} *'),
                    items: availableLists.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                    validator: (item) {
                      if (item == null) {
                        return Translations.of(context).validation_chooseList;
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        listId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: '${Translations.of(context).name} *'),
                    initialValue: name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Translations.of(context).name;
                      }

                      return null;
                    },
                    onChanged: (value) {
                      name = value;
                    },
                  ),
                  const SizedBox(height: 10),
                  CheckboxListTile(
                      title: Text(Translations.of(context).experienced),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      value: experienced,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            experienced = value;
                          });
                        }
                      }),
                  const SizedBox(height: 10),
                  InputDecorator(
                    decoration:
                        inputDecoration.copyWith(labelText: Translations.of(context).rating, border: InputBorder.none),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: RatingBar.builder(
                        initialRating: rating.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 10,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (newRating) {
                          setState(() {
                            rating = newRating.toInt();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  InputDecorator(
                    decoration:
                        inputDecoration.copyWith(labelText: Translations.of(context).tags, border: InputBorder.none),
                    child: Wrap(
                      spacing: 8,
                      children: [
                        ...tags.map((e) => TagItem(tag: e)),
                        ActionChip(
                          avatar: const Icon(Icons.edit),
                          label: Text(Translations.of(context).edit),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return Column(
                                    children: availableTags
                                        .map((e) => ListTile(
                                              leading: tags.contains(e) ? const Icon(Icons.check) : null,
                                              title: Text(e.name),
                                              tileColor: e.color,
                                              onTap: () {
                                                setState(() {
                                                  if (tags.contains(e)) {
                                                    tags.remove(e);
                                                  } else {
                                                    tags.add(e);
                                                  }
                                                });
                                              },
                                            ))
                                        .toList(),
                                  );
                                });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: inputDecoration.copyWith(labelText: Translations.of(context).description),
                    maxLines: null,
                    controller: _textEditingController,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _trySave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });

      await PersistenceService.of(context)
          .createItem(listId!, name!, description, rating, experienced, tags)
          .then((value) {
        value.fold((l) {
          showErrorMessage(context, Translations.of(context).addItem_error, l.error, l.stackTrace);
        }, (r) {
          Navigator.of(context).pop(r);
        });
      });

      setState(() {
        isSaving = false;
      });
    }
  }
}
