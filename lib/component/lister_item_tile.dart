import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';

class ListerItemTile extends StatelessWidget {
  final ListerItem listItem;

  const ListerItemTile(this.listItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: listItem.experienced ? Icon(Icons.check) : Icon(Icons.close),
      title: Text(listItem.name),
      subtitle: Text(listItem.description, maxLines: 2, overflow: TextOverflow.ellipsis,),
      trailing: Text(listItem.rating.toString()),
    );
  }
}
