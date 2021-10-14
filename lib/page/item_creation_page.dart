import 'package:flutter/material.dart';
import 'package:lister_app/component/save_loading_button.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/service/persistence_service.dart';

class ItemCreationPage extends StatefulWidget {
  static const String routeName = "ItemCreationPage";

  final int listId;

  const ItemCreationPage(this.listId, {Key? key}) : super(key: key);

  @override
  _ItemCreationPageState createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  String? name;
  String? description;
  bool experienced = false;
  int rating = 0;

  final GlobalKey<FormState> formKey = GlobalKey();
  bool isSaving = false;

  final InputDecoration inputDecoration = const InputDecoration();

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
                TextFormField(
                  decoration: inputDecoration.copyWith(labelText: 'Name *'),
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name must not be empty!';
                    }
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
                DropdownButtonFormField<int>(
                  value: rating,
                  decoration: inputDecoration.copyWith(labelText: 'Rating'),
                  items: Iterable<int>.generate(11)
                      .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      rating = value;
                    }
                  },
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

      try {
        ListerItem newItem = await PersistenceService.of(context)
            .createItem(widget.listId, name!, description ?? '', rating, experienced);
        Navigator.of(context).pop(newItem);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Could not create entry!', style: TextStyle(color: Colors.white))));
      }

      setState(() {
        isSaving = false;
      });
    }
  }
}
