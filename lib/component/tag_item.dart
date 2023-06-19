import 'package:flutter/material.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/util/utils.dart';

class TagItem extends StatelessWidget {
  final ListerTag tag;

  const TagItem({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(Icons.tag, color: Utils.getContrastingColor(tag.color)),
      label: Text(tag.name, style: TextStyle(color: Utils.getContrastingColor(tag.color))),
      backgroundColor: tag.color,
    );
  }
}
