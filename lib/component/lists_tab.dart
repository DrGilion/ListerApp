import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/list_creation_dialog.dart';
import 'package:lister_app/component/lister_page.dart';
import 'package:lister_app/component/popup_options.dart';
import 'package:lister_app/component/textfield_dialog.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/extensions.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/util/utils.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class ListsTab extends StatefulWidget {
  const ListsTab({super.key});

  @override
  State<ListsTab> createState() => _ListsTabState();
}

class _ListsTabState extends State<ListsTab> {
  //showcase keys
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  Map<int, ListerList> lists = {};

  @override
  void initState() {
    super.initState();

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).lists_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          lists = Map<int, ListerList>.fromIterable(r, key: (it) => it.id);
          if (ListNavigationData.of(context).currentListId == null) {
            ListNavigationData.of(context).currentListId = lists.values.firstOrNull?.id;
          }
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
              key: _scaffoldKey,
              appBar: _buildAppBar(context),
              drawer: _buildDrawer(context),
              body: _buildBody(context),
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        _getAppbarTitle(context),
        style: TextStyle(color: _getForegroundColor(context)),
      ),
      backgroundColor: _getBackgroundColor(context),
      elevation: 0,
      leading: Builder(builder: (context) {
        return Showcase(
          key: _two,
          description: Translations.of(context).tutorial_createList2,
          disposeOnTap: false,
          onTargetClick: () async {
            Scaffold.of(context).openDrawer();
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) ShowCaseWidget.of(context).startShowCase([_three]);
          },
          child: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu, color: _getForegroundColor(context)),
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
          icon: Icon(
            Icons.help,
            color: _getForegroundColor(context),
          ),
          tooltip: Translations.of(context).tutorial_show,
          onPressed: () {
            ShowCaseWidget.of(context).startShowCase([
              if (lists.isEmpty) _one,
              _two,
            ]);
          },
        ),
        PopupMenuButton(
          color: _getForegroundColor(context),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              value: PopupOptions.settings,
              child: ListTile(
                leading: const Icon(Icons.settings),
                title: Text(Translations.of(context).settings_show),
              ),
            ),
            /*PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.update),
                        title: Text(Translations.of(context).update),
                      ),
                    ),*/
          ],
          onSelected: (value) async {
            switch (value) {
              case PopupOptions.settings:
                context.push('/settings');
                break;

              case PopupOptions.update:
                if (_updateInfo?.updateAvailability == UpdateAvailability.updateAvailable) {
                  InAppUpdate.startFlexibleUpdate().then((_) {
                    setState(() {
                      _flexibleUpdateAvailable = true;
                    });
                  }).catchError((e) {
                    showSnack(e.toString());
                  });
                }
                break;
            }
          },
        )
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(child: Text(Translations.of(context).list_choose)),
            ),
            SingleChildScrollView(
              child: Column(
                children: lists.values
                    .map<Widget>(
                      (simpleList) => ListTile(
                        tileColor: simpleList.color,
                        //leading: Text('ID: ${simpleList.id}'),
                        title: Text(
                          simpleList.name,
                          style: TextStyle(color: Utils.getContrastingColor(simpleList.color)),
                        ),
                        trailing: PopupMenuButton<String>(
                          color: Utils.getContrastingColor(simpleList.color),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                                value: PopupOptions.rename,
                                child: ListTile(title: Text(Translations.of(context).rename))),
                            PopupMenuItem(
                                value: PopupOptions.delete,
                                child: ListTile(title: Text(MaterialLocalizations.of(context).deleteButtonTooltip)))
                          ],
                          onSelected: (value) async {
                            switch (value) {
                              case PopupOptions.rename:
                                final String? newName = await showTextFieldDialog(
                                    context, Translations.of(context).list_rename, Translations.of(context).name,
                                    initialValue: simpleList.name);
                                if (newName != null && mounted) {
                                  PersistenceService.of(context)
                                      .updateList(simpleList.id, newName: newName)
                                      .then((value) {
                                    value.fold((l) {
                                      showErrorMessage(
                                          context,
                                          Translations.of(context).list_rename_error(simpleList.name),
                                          l.error,
                                          l.stackTrace);
                                    }, (r) {
                                      setState(() {
                                        simpleList = r;
                                      });
                                    });
                                  });
                                }

                                break;
                              case PopupOptions.delete:
                                final bool decision = await showConfirmationDialog(
                                  context,
                                  Translations.of(context).list_delete,
                                  Translations.of(context).list_delete_confirm(simpleList.name),
                                );

                                if (decision && mounted) {
                                  PersistenceService.of(context).deleteList(simpleList.id).then((value) {
                                    value.fold((l) {
                                      showErrorMessage(
                                          context, Translations.of(context).list_delete_error, l.error, l.stackTrace);
                                    }, (r) {
                                      setState(() {
                                        lists.removeWhere((key, value) => key == simpleList.id);
                                        ListNavigationData.of(context).currentListId = lists.keys.firstOrNull;
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
                            ListNavigationData.of(context).currentListId = simpleList.id;
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
              description: Translations.of(context).tutorial_createList3,
              disposeOnTap: false,
              onTargetClick: () {
                ShowCaseWidget.of(context).dismiss();
                _tryAddList(context, withShowcase: false);
              },
              child: ListTile(
                leading: const Icon(Icons.add),
                title: Text(Translations.of(context).list_add),
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

  Color _getForegroundColor(BuildContext context) {
    return lists.isEmpty || ListNavigationData.of(context).currentListId == null
        ? Colors.black
        : Utils.getContrastingColor(lists[ListNavigationData.of(context).currentListId]!.color);
  }

  Color? _getBackgroundColor(BuildContext context) {
    return lists.isEmpty || ListNavigationData.of(context).currentListId == null
        ? null
        : lists[ListNavigationData.of(context).currentListId]!.color.let((it) => it);
  }

  Widget _buildBody(BuildContext context) {
    if (lists.isEmpty) {
      return Center(
        child: Showcase(
          key: _one,
          description: Translations.of(context).tutorial_createList1,
          onBarrierClick: () {
            ShowCaseWidget.of(context).next();
          },
          disposeOnTap: false,
          onTargetClick: () {
            ShowCaseWidget.of(context).dismiss();
            _tryAddList(context, withShowcase: true);
          },
          child: TextButton.icon(
              onPressed: () => _tryAddList(context),
              icon: const Icon(Icons.add),
              label: Text(Translations.of(context).list_add)),
        ),
      );
    }

    return ListerPage(
      lists[ListNavigationData.of(context).currentListId]!,
      key: ValueKey(lists[ListNavigationData.of(context).currentListId]!.id),
    );
  }

  Future<void> _tryAddList(BuildContext context, {bool withShowcase = false}) async {
    logger.d('add list with showcase? $withShowcase');
    final Tuple2<String, Color>? data =
        await showListCreationDialog(context, Translations.of(context).list_create, Translations.of(context).name);

    if (data != null && mounted) {
      PersistenceService.of(context).createList(data.value1, data.value2).then((value) {
        value.fold((l) {
          showErrorMessage(context, Translations.of(context).list_create_error(data), l.error, l.stackTrace);
        }, (r) {
          setState(() {
            lists[r.id] = r;
            if (lists.length == 1) {
              ListNavigationData.of(context).currentListId = r.id;
            }
          });
        });
      });
    }
  }

  AppUpdateInfo? _updateInfo;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(content: Text(text)));
    }
  }
}
