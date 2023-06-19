import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lister_app/notification/item_added_notifier.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:lister_app/voice_assist/command/command.dart';

/// opens the view to create something
class CreateCommand extends Command<void> {
  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context) async {
      final match = RegExp(r'create (.+)').firstMatch(rawCommand);
      if(match == null) throw ArgumentError();

      final name = toBeginningOfSentenceCase(match.group(1)!)!;
      final listId = ListNavigationData.of(context).currentListId;
      if (listId != null) {
        await PersistenceService.of(context).createItem(listId, name, '', 0, false, []).then((value) =>
            value.fold((l) => logger.e('could not create item $name'), (r) => ItemAddedNotifier.of(context).add(r.item)));
      } else {
        logger.e('no list is selected for inserted item $name');
      }

      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('create');
  }
}
