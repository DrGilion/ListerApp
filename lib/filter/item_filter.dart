import 'package:flutter/material.dart';
import 'package:lister_app/filter/base_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';
import 'package:provider/provider.dart';

class ItemFilter extends BaseFilter {
  static ItemFilter of(BuildContext context) => Provider.of<ItemFilter>(context, listen: false);

  @override
  String defaultSorting = 'name';

  @override
  SortDirection defaultDirection = SortDirection.desc;
}
