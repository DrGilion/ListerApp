import 'package:flutter/material.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/viewmodel/list_navigation_data.dart';
import 'package:lister_app/voice_assist/command/command.dart';

/// Navigate to a specific place in the application
class SwitchListCommand extends Command<void> {
  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context) async {
      final listName = rawCommand.split(' ').last;
      await PersistenceService.of(context).findListByName(listName).then((value) => value.fold(
            (l) => logger.e('List with name $listName not found'),
            (r) {
              ListNavigationData.of(context).currentListId = r.id;
            },
          ));
      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('switch to');
  }
}
