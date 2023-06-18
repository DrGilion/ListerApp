import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lister_app/filter/base_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';
import 'package:lister_app/generated/l10n.dart';

class SortButton<F extends BaseFilter> extends StatelessWidget {
  final F filter;
  final Map<String, Tuple2<IconData, String>> optionsMap;

  const SortButton({super.key, required this.filter, required this.optionsMap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort, color: Colors.grey),
      onPressed: () {
        showDialog<Tuple2<String, SortDirection>>(
            context: context,
            builder: (context) => SortDialog(filter: filter, optionsMap: optionsMap));
      },
    );
  }
}

class SortDialog extends StatefulWidget {
  final BaseFilter filter;
  final Map<String, Tuple2<IconData, String>> optionsMap;

  const SortDialog({super.key, required this.filter, required this.optionsMap});

  @override
  State<SortDialog> createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  late String selectedSortField;
  late SortDirection selectedSortDirection;

  @override
  void initState() {
    super.initState();

    selectedSortField = widget.filter.sorting.value1;
    selectedSortDirection = widget.filter.sorting.value2;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Translations.of(context).sortBy),
      content: StatefulBuilder(builder: (context, setStateFn) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...widget.optionsMap.entries.map((e) => RadioListTile<String>(
                groupValue: selectedSortField,
                value: e.key,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Icon(e.value.value1, color: Colors.black),
                    const SizedBox(width: 16),
                    Text(e.value.value2),
                  ],
                ),
                onChanged: (String? value) {
                  setStateFn(() {
                    selectedSortField = value!;
                  });
                },
              )),
              const Divider(),
              RadioListTile<SortDirection>(
                groupValue: selectedSortDirection,
                value: SortDirection.asc,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Icon(FontAwesomeIcons.arrowUp, color: Colors.black),
                    const SizedBox(width: 16),
                    Text(Translations.of(context).asc),
                  ],
                ),
                onChanged: (SortDirection? value) {
                  setStateFn(() {
                    selectedSortDirection = value!;
                  });
                },
              ),
              RadioListTile<SortDirection>(
                groupValue: selectedSortDirection,
                value: SortDirection.desc,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    const Icon(FontAwesomeIcons.arrowDownLong, color: Colors.black),
                    const SizedBox(width: 16),
                    Text(Translations.of(context).desc),
                  ],
                ),
                onChanged: (SortDirection? value) {
                  setStateFn(() {
                    selectedSortDirection = value!;
                  });
                },
              ),
            ],
          ),
        );
      }),
      actions: [
        TextButton(
            onPressed: () {
              widget.filter.resetSorting();
              Navigator.of(context).pop();
            },
            child: Text(Translations.of(context).reset)),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
        TextButton(
            onPressed: () {
              widget.filter.sorting = Tuple2(selectedSortField, selectedSortDirection);
              Navigator.of(context).pop();
            },
            child: Text(MaterialLocalizations.of(context).saveButtonLabel))
      ],
    );
  }
}

