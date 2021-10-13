import 'package:flutter/material.dart';
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

  final InputDecoration inputDecoration = InputDecoration(prefixIcon: Icon(Icons.edit));

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Entry'),
          actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: _trySave,
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: inputDecoration.copyWith(
                    labelText: 'Name *'
                  ),
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name must not be empty!';
                    }
                  },
                ),
                CheckboxListTile(
                  title: Text("Experienced"),
                    value: experienced,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          experienced = value;
                        });
                      }
                    }),
                TextFormField(
                  decoration: inputDecoration.copyWith(
                      labelText: 'Rating'
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: rating.toString(),
                ),
                TextFormField(
                  decoration: inputDecoration.copyWith(
                      labelText: 'Description'
                  ),
                  initialValue: description,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _trySave() {
    if (formKey.currentState!.validate()) {
      ListerItem newItem =
          PersistenceService.of(context).createItem(widget.listId, name!, description ?? '', rating, experienced);
      Navigator.of(context).pop(newItem);
    }
  }
}
