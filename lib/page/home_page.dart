import 'package:flutter/material.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String optionAdd = "add";

  int currentIndex = 0;

  late List<SimpleListerList> lists;

  @override
  void initState() {
    lists = PersistenceService.of(context).getListsSimple();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lister'),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: optionAdd,
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Add List'),
                  ),
                )
              ];
            },
            onSelected: (value){
              switch(value){
                case optionAdd:
                  _tryAddList(context);
                  break;
              }
            },)
          ],
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(lists[index].title),
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
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
        body: ListerPage(PersistenceService.of(context).getList(lists[currentIndex].id)),
      ),
    );
  }

  Future<void> _tryAddList(BuildContext context) async {
    final String? name = await showDialog<String>(
        context: context,
        builder: (context) {
          final GlobalKey<FormState> formKey = GlobalKey();
          String? name;
          return AlertDialog(
            title: Text('Create List'),
            content: Form(
                key: formKey,
                child: TextFormField(
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'The name must not be empty';
                    } else {
                      return null;
                    }
                  },
                )),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop(name);
                    }
                  },
                  child: Text(MaterialLocalizations.of(context).saveButtonLabel)),
            ],
          );
        });

    if (name != null) {
      final SimpleListerList newList = PersistenceService.of(context).createList(name);
      setState(() {
        lists.add(newList);
      });
    }
  }
}
