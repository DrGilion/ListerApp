import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/filter/base_filter.dart';
import 'package:lister_app/filter/sort_direction.dart';

class SortButton<F extends BaseFilter> extends StatelessWidget {
  final F filter;
  final Map<String, String> optionsMap;

  const SortButton({Key? key, required this.filter, required this.optionsMap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.sort, color: Colors.grey),
      onPressed: () async {
        String selectedSortField = filter.sorting.value1;
        SortDirection selectedSortDirection = filter.sorting.value2;
        final Tuple2<String, SortDirection>? result = await showDialog<Tuple2<String, SortDirection>>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Sort by'),
                content: StatefulBuilder(builder: (context, setStateFn) {
                  return Column(
                    children: [
                      ...optionsMap.entries.map((e) => RadioListTile<String>(
                            groupValue: selectedSortField,
                            value: e.key,
                            title: Text(e.value),
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
                        title: const Text('Ascending'),
                        onChanged: (SortDirection? value) {
                          setStateFn(() {
                            selectedSortDirection = value!;
                          });
                        },
                      ),
                      RadioListTile<SortDirection>(
                        groupValue: selectedSortDirection,
                        value: SortDirection.desc,
                        title: const Text('Descending'),
                        onChanged: (SortDirection? value) {
                          setStateFn(() {
                            selectedSortDirection = value!;
                          });
                        },
                      ),
                    ],
                  );
                }),
                actions: [
                  TextButton(onPressed: () {
                    filter.resetSorting();
                    Navigator.of(context).pop();
                  }, child: const Text('Reset')),
                  TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.of(context).pop(Tuple2(selectedSortField, selectedSortDirection)),
                      child: const Text('Save'))
                ],
              );
            });

        if (result != null) {
          filter.sorting = result;
        }
      },
    );
  }
}
