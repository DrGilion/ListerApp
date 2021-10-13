import 'package:flutter/material.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/component/textfield_dialog.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String optionRename = "rename";
  static const String optionDelete = "delete";
  int currentIndex = 0;

  List<SimpleListerList>? lists;

  @override
  void initState() {
    super.initState();

    PersistenceService.of(context).getListsSimple().then((value) {
      setState(() {
        lists = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_getAppbarTitle()),
        ),
        drawer: Drawer(
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
                        title: Text(lists![index].name),
                        trailing: PopupMenuButton<String>(
                          itemBuilder: (context) => [
                            PopupMenuItem(value: optionRename, child: ListTile(title: Text('Rename'))),
                            PopupMenuItem(value: optionDelete, child: ListTile(title: Text('Delete')))
                          ],
                          onSelected: (value) async {
                            switch (value) {
                              case optionRename:
                                final String? newName = await showTextFieldDialog(context, 'Rename List', 'Name',
                                    initialValue: lists![index].name);
                                if (newName != null) {
                                  final int updatedCount =
                                      await PersistenceService.of(context).renameList(lists![index].id!, newName);
                                  if (updatedCount > 0) {
                                    setState(() {
                                      lists![index].name = newName;
                                    });
                                  }
                                }

                                break;
                              case optionDelete:
                                final int deletedCount =
                                    await PersistenceService.of(context).deleteList(lists![index].id!);
                                if (deletedCount > 0) {
                                  setState(() {
                                    currentIndex = 0;
                                    lists!.removeAt(index);
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
                  leading: Icon(Icons.add),
                  title: Text('Add List'),
                  onTap: () => _tryAddList(context),
                )
              ],
            ),
          ),
        ),
        body: _buildBody(context),
      ),
    );
  }

  String _getAppbarTitle() {
    return lists == null || lists!.isEmpty ? 'Lister' : lists![currentIndex].name;
  }

  Widget _buildBody(BuildContext context) {
    if (lists == null) {
      return Center(child: CircularProgressIndicator());
    }

    if (lists!.isEmpty) {
      return Center(
        child: TextButton.icon(onPressed: () => _tryAddList(context), icon: Icon(Icons.add), label: Text('Add List')),
      );
    }

    return ListerPage(lists![currentIndex]);
  }

  Future<void> _tryAddList(BuildContext context) async {
    final String? name = await showTextFieldDialog(context, 'Create List', 'Name');

    if (name != null) {
      final SimpleListerList newList = await PersistenceService.of(context).createList(name);
      setState(() {
        lists?.add(newList);
      });
    }
  }
}
