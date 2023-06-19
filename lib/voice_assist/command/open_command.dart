import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/voice_assist/command/command.dart';

/// navigates to the detail view of something e.g. a [ListerItem]
class OpenCommand extends Command<void> {
  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context) async {
      final match = RegExp(r'open (.+)').firstMatch(rawCommand);
      if(match == null) throw ArgumentError();

      final itemName = match.group(1)!;
      PersistenceService.of(context).findListerItemByName(itemName).then((value) => value.fold(
            (l) => logger.e('Item with name $itemName not found'),
            (r) {
              context.push('/item/details', extra: r);
            },
          ));

      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('open');
  }
}
