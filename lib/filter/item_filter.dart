import 'package:flutter/material.dart';
import 'package:lister_app/filter/base_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';
import 'package:provider/provider.dart';

class ItemFilter extends BaseFilter {
  static ItemFilter of(BuildContext context) => Provider.of<ItemFilter>(context, listen: false);

  @override
  String defaultSorting = sortingName;

  static const String sortingName = 'name';
  static const String sortingRating = 'rating';
  static const String sortingExperienced = 'experienced';
  static const String sortingCreatedOn = 'created_on';
  static const String sortingModifiedOn = 'modified_on';

  @override
  SortDirection defaultDirection = SortDirection.asc;
}
