import 'package:flutter/material.dart';

class ItemCreationPage extends StatefulWidget {
  static const String routeName = "ItemCreationPage";

  const ItemCreationPage({Key? key}) : super(key: key);

  @override
  _ItemCreationPageState createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  String? name;
  String? description;
  bool? experienced;
  int? rating;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(),
                TextFormField(),
                CheckboxListTile(
                    value: experienced,
                    onChanged: (value) {
                      setState(() {
                        experienced = value;
                      });
                    }),
                TextFormField(
                  keyboardType: TextInputType.number,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
