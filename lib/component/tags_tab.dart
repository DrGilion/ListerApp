import 'package:dartz/dartz.dart' show Tuple2;
import 'package:flutter/material.dart';
import 'package:lister_app/component/confimation_dialog.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/popup_options.dart';
import 'package:lister_app/component/tag_creation_dialog.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/service/lister_database.dart';
import 'package:lister_app/service/persistence_service.dart';

class TagsTab extends StatefulWidget {
  const TagsTab({super.key});

  @override
  State<TagsTab> createState() => _TagsTabState();
}

class _TagsTabState extends State<TagsTab> {
  List<ListerTag> _tags = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _loadTags(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Translations.of(context).tags),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: Translations.of(context).tags_create,
            onPressed: () => _tryAddTag(context),
          )
        ],
      ),
      body: (_tags.isEmpty)
          ? Center(
              child: TextButton.icon(
                  onPressed: () => _tryAddTag(context),
                  icon: const Icon(Icons.add),
                  label: Text(Translations.of(context).tag_add)),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await _loadTags(context);
              },
              child: ListView.separated(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: const EdgeInsets.only(bottom: kToolbarHeight),
                itemBuilder: (_, index) => _buildTagWidget(
                  context,
                  _tags[index],
                ),
                separatorBuilder: (_, __) => const Divider(
                  color: Colors.black,
                ),
                itemCount: _tags.length,
              ),
            ),
    );
  }

  Widget _buildTagWidget(BuildContext context, ListerTag tag) {
    return GestureDetector(
      key: ValueKey(tag.id),
      onLongPress: () {
        final RenderBox button = context.findRenderObject()! as RenderBox;
        final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
        final RelativeRect position = RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        );

        showMenu<String>(
          context: context,
          position: position,
          items: [
            PopupMenuItem(
              value: PopupOptions.delete,
              child: ListTile(leading: const Icon(Icons.delete), title: Text(Translations.of(context).tags_delete)),
            )
          ],
        ).then((value) async {
          switch (value) {
            case PopupOptions.delete:
              final bool decision = await showConfirmationDialog(
                context,
                Translations.of(context).tags_delete,
                Translations.of(context).tags_delete_confirm(tag.name),
              );

              if (decision && mounted) {
                _deleteTag(context, tag.id);
              }
              break;
          }
        });
      },
      child: ListTile(
        title: Text(tag.name),
        tileColor: tag.color,
      ),
    );
  }

  Future _loadTags(BuildContext context) {
    return PersistenceService.of(context).getTags().then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).tags_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          _tags = r;
        });
      });
    });
  }

  Future _tryAddTag(BuildContext context) async {
    final Tuple2<String, Color>? data =
        await showTagCreationDialog(context, Translations.of(context).tags_create, Translations.of(context).name);

    if (data != null && mounted) {
      PersistenceService.of(context).createTag(data.value1, data.value2).then((value) {
        value.fold((l) {
          showErrorMessage(context, Translations.of(context).tags_create_error(data.value1), l.error, l.stackTrace);
        }, (r) {
          setState(() {
            _tags.add(r);
          });
        });
      });
    }
  }

  Future _deleteTag(BuildContext context, int tagId) async {
    PersistenceService.of(context).deleteTag(tagId).then((value) {
      value.fold((l) {
        showErrorMessage(context, Translations.of(context).tags_delete_error, l.error, l.stackTrace);
      }, (r) {
        setState(() {
          _tags.removeWhere((element) => element.id == tagId);
        });
      });
    });
  }
}
