import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';

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
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entry details'),
        ),
        body: SingleChildScrollView(
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
                  value: listerItem.experienced,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        listerItem.experienced = value;
                      });
                    }
                  }),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Rating'),
                keyboardType: TextInputType.number,
                initialValue: listerItem.rating.toString(),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: listerItem.description,
              )
            ],
          ),
        ),
      ),
    );
  }
}
