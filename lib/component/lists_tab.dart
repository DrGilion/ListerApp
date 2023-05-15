import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/list_creation_dialog.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/component/textfield_dialog.dart';
import 'package:lister_app/extensions.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({super.key});

  @override
  State<ListsTab> createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  static const String optionRename = "rename";
  static const String optionDelete = "delete";

  //showcase keys
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  Map<int, SimpleListerList> lists = {};

  @override
  void initState() {
    super.initState();

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve lists!', l.error, l.stackTrace);
      }, (r) {
        setState(() {
          lists = Map<int, SimpleListerList>.fromIterable(r, key: (it) => it.id);
          ListNavigationData.of(context).currentListId = lists.values.firstOrNull?.id;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      disableBarrierInteraction: true,
      builder: Builder(builder: (context) {
        return Consumer<ListNavigationData>(
          builder: (BuildContext context, ListNavigationData value, Widget? child) => SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text(_getAppbarTitle(context)),
                backgroundColor: _getBackgroundColor(context),
                leading: Builder(builder: (context) {
                  return Showcase(
                    key: _two,
                    description: 'Or navigate to the drawer...',
                    disposeOnTap: false,
                    onTargetClick: () async {
                      Scaffold.of(context).openDrawer();
                      await Future.delayed(const Duration(milliseconds: 500));
                      if (mounted) ShowCaseWidget.of(context).startShowCase([_three]);
                    },
                    child: Builder(
                      builder: (BuildContext context) {
                        return IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                        );
                      },
                    ),
                  );
                }),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.help),
                    tooltip: 'Show tutorial',
                    onPressed: () {
                      ShowCaseWidget.of(context).startShowCase([
                        if (lists.isEmpty) _one,
                        _two,
                      ]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Show settings',
                    onPressed: () {
                      context.push('/settings');
                    },
                  )
                ],
              ),
              drawer: _buildDrawer(context),
              body: _buildBody(context),
            ),
          ),
        );
      }),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(child: Text('Choose List')),
            ),
            SingleChildScrollView(
              child: Column(
                children: lists.values
                    .map<Widget>(
                      (simpleList) => ListTile(
                        tileColor: Color(simpleList.color),
                        leading: Text('ID: ${simpleList.id}'),
                        title: Text(simpleList.name),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: optionRename, child: ListTile(title: Text('Rename'))),
                            PopupMenuItem(value: optionDelete, child: ListTile(title: Text('Delete')))
                          ],
                          onSelected: (value) async {
                            switch (value) {
                              case optionRename:
                                final String? newName = await showTextFieldDialog(context, 'Rename list', 'Name',
                                    initialValue: simpleList.name);
                                if (newName != null && mounted) {
                                  PersistenceService.of(context).renameList(simpleList, newName).then((value) {
                                    value.fold((l) {
                                      showErrorMessage(
                                          context, 'Could not rename list ${simpleList.name}', l.error, l.stackTrace);
                                    }, (r) {
                                      if (r > 0) {
                                        setState(() {
                                          simpleList.name = newName;
                                        });
                                      } else {
                                        showErrorMessage(context, 'Could not rename list ${simpleList.name}',
                                            'Failed to rename list', StackTrace.current);
                                      }
                                    });
                                  });
                                }

                                break;
                              case optionDelete:
                                final bool decision = await showConfirmationDialog(
                                  context,
                                  'Delete list',
                                  'Are you sure that you want to delete the list "${simpleList.name}"?',
                                );

                                if (decision && mounted) {
                                  PersistenceService.of(context).deleteList(simpleList.id!).then((value) {
                                    value.fold((l) {
                                      showErrorMessage(context, 'Could not delete list!', l.error, l.stackTrace);
                                    }, (r) {
                                      setState(() {
                                        ListNavigationData.of(context).currentListId = 0;
                                        lists.removeWhere((key, value) => key == simpleList.id);
                                      });
                                    });
                                  });
                                }
                                break;
                            }
                          },
                        ),
                        onTap: () {
                          setState(() {
                            ListNavigationData.of(context).currentListId = simpleList.id!;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            Showcase(
              key: _three,
              description: 'Click here to create a new list',
              disposeOnTap: false,
              onTargetClick: () {
                ShowCaseWidget.of(context).dismiss();
                _tryAddList(context, withShowcase: false);
              },
              child: ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Add List'),
                onTap: () => _tryAddList(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getAppbarTitle(BuildContext context) {
    return lists.isEmpty || ListNavigationData.of(context).currentListId == null
        ? 'Lister'
        : lists[ListNavigationData.of(context).currentListId]!.name;
  }

  Color? _getBackgroundColor(BuildContext context) {
    return lists.isEmpty || ListNavigationData.of(context).currentListId == null
        ? null
        : lists[ListNavigationData.of(context).currentListId]!.color.let((it) => Color(it));
  }

  Widget _buildBody(BuildContext context) {
    if (lists.isEmpty) {
      return Center(
        child: Showcase(
          key: _one,
          description: 'Click here to create a new list',
          onBarrierClick: () {
            ShowCaseWidget.of(context).next();
          },
          disposeOnTap: false,
          onTargetClick: () {
            ShowCaseWidget.of(context).dismiss();
            _tryAddList(context, withShowcase: true);
          },
          child: TextButton.icon(
              onPressed: () => _tryAddList(context), icon: const Icon(Icons.add), label: const Text('Add List')),
        ),
      );
    }

    return ListerPage(
      lists[ListNavigationData.of(context).currentListId]!,
      key: ValueKey(lists[ListNavigationData.of(context).currentListId]!.id),
    );
  }

  Future<void> _tryAddList(BuildContext context, {bool withShowcase = false}) async {
    print('add list with showcase? $withShowcase');
    final Tuple2<String, Color>? data = await showListCreationDialog(context, 'Create List', 'Name');

    if (data != null && mounted) {
      PersistenceService.of(context).createList(data.value1, data.value2).then((value) {
        value.fold((l) {
          showErrorMessage(context, 'Could not create list "$data"!', l.error, l.stackTrace);
        }, (r) {
          setState(() {
            lists[r.id!] = r;
          });
        });
      });
    }
  }
}
