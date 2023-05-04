import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/save_loading_button.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';

class ItemCreationPage extends StatefulWidget {
  static const String routeName = "ItemCreationPage";

  final int? initialListId;

  const ItemCreationPage(this.initialListId, {super.key});

  @override
  _ItemCreationPageState createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  int? listId;
  String? name;
  String? description;
  bool experienced = false;
  int rating = 0;

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isSaving = false;

  final InputDecoration inputDecoration = const InputDecoration();

  List<SimpleListerList> availableLists = [];

  @override
  void initState() {
    super.initState();

    listId = widget.initialListId;

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve lists!', l.error, l.stackTrace);
      }, (r) {
        setState(() {
          availableLists = r;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Entry'),
          actions: [
            SaveLoadingButton(
              isSaving: isSaving,
              onPressed: () => _trySave(context),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: listId,
                  decoration: inputDecoration.copyWith(labelText: 'List *'),
                  items: availableLists.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  validator: (item) {
                    if (item == null) {
                      return 'You must choose a list!';
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
                  decoration: inputDecoration.copyWith(labelText: 'Name *'),
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name must not be empty!';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                    title: const Text("Experienced"),
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
                  decoration: inputDecoration.copyWith(labelText: 'Rating', border: InputBorder.none),
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
                Expanded(
                  child: TextFormField(
                    decoration: inputDecoration.copyWith(labelText: 'Description'),
                    maxLines: null,
                    initialValue: description,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                )
              ],
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
          .createItem(listId!, name!, description ?? '', rating, experienced)
          .then((value) {
        value.fold((l) {
          showErrorMessage(context, 'Could not create entry!', l.error, l.stackTrace);
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
