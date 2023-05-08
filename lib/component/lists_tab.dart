import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/list_creation_dialog.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/component/textfield_dialog.dart';
import 'package:lister_app/extensions.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';
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

  int currentIndex = 0;

  List<SimpleListerList>? lists;

  @override
  void initState() {
    super.initState();

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve lists!', l.error, l.stackTrace);
      }, (r) {
        setState(() {
          lists = r;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      disableBarrierInteraction: true,
      builder: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_getAppbarTitle()),
              backgroundColor:
                  lists == null || lists!.isEmpty ? null : lists!.elementAt(currentIndex).color.let((it) => Color(it)),
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
                      if (lists!.isEmpty) _one,
                      _two,
                    ]);
                  },
                )
              ],
            ),
            drawer: _buildDrawer(context),
            body: _buildBody(context),
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
            ListView.builder(
                shrinkWrap: true,
                itemCount: lists?.length ?? 0,
                itemBuilder: (context, index) {
                  return ListTile(
                    tileColor: Color(lists![index].color),
                    leading: Text('ID: ${lists![index].id}'),
                    title: Text(lists![index].name),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: optionRename, child: ListTile(title: Text('Rename'))),
                        PopupMenuItem(value: optionDelete, child: ListTile(title: Text('Delete')))
                      ],
                      onSelected: (value) async {
                        switch (value) {
                          case optionRename:
                            final String? newName = await showTextFieldDialog(context, 'Rename list', 'Name',
                                initialValue: lists![index].name);
                            if (newName != null && mounted) {
                              PersistenceService.of(context).renameList(lists![index], newName).then((value) {
                                value.fold((l) {
                                  showErrorMessage(
                                      context, 'Could not rename list ${lists![index].name}', l.error, l.stackTrace);
                                }, (r) {
                                  if (r > 0) {
                                    setState(() {
                                      lists![index].name = newName;
                                    });
                                  } else {
                                    showErrorMessage(context, 'Could not rename list ${lists![index].name}',
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
                              'Are you sure that you want to delete the list "${lists![index].name}"?',
                            );

                            if (decision && mounted) {
                              PersistenceService.of(context).deleteList(lists![index].id!).then((value) {
                                value.fold((l) {
                                  showErrorMessage(context, 'Could not delete list!', l.error, l.stackTrace);
                                }, (r) {
                                  setState(() {
                                    currentIndex = 0;
                                    lists!.removeAt(index);
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
                        currentIndex = index;
                      });
                      Navigator.of(context).pop();
                    },
                  );
                }),
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

  String _getAppbarTitle() {
    return lists == null || lists!.isEmpty ? 'Lister' : lists![currentIndex].name;
  }

  Widget _buildBody(BuildContext context) {
    if (lists == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (lists!.isEmpty) {
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

    return ListerPage(lists![currentIndex], key: ValueKey(lists![currentIndex].id));
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
            lists?.add(r);
          });
        });
      });
    }
  }
}
