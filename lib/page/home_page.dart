import 'package:flutter/material.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/component/textfield_dialog.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:showcaseview/showcaseview.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String optionRename = "rename";
  static const String optionDelete = "delete";

  //showcase keys
  GlobalKey _one = GlobalKey();
  GlobalKey _two = GlobalKey();
  GlobalKey _three = GlobalKey();

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
      builder: Builder(builder: (context) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(_getAppbarTitle()),
              actions: [
                IconButton(
                  icon: const Icon(Icons.help),
                  tooltip: 'Show tutorial',
                  onPressed: () {
                    ShowCaseWidget.of(context).startShowCase([_one, _two, _three]);
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
                            if (newName != null) {
                              PersistenceService.of(context).renameList(lists![index].id!, newName).then((value) {
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

                            if (decision) {
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
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add List'),
              onTap: () => _tryAddList(context),
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
          child: TextButton.icon(
              onPressed: () => _tryAddList(context), icon: const Icon(Icons.add), label: const Text('Add List')),
        ),
      );
    }

    return ListerPage(lists![currentIndex], key: ValueKey(lists![currentIndex].id));
  }

  Future<void> _tryAddList(BuildContext context) async {
    final String? name = await showTextFieldDialog(context, 'Create List', 'Name');

    if (name != null) {
      PersistenceService.of(context).createList(name).then((value) {
        value.fold((l) {
          showErrorMessage(context, 'Could not create list "$name"!', l.error, l.stackTrace);
        }, (r) {
          setState(() {
            lists?.add(r);
          });
        });
      });
    }
  }
}
