import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lister_app/viewmodel/top_navigation_data.dart';
import 'package:lister_app/voice_assist/command/command.dart';

/// Navigate to a specific place in the application
class GoToCommand extends Command<void> {
  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context) {
      final destination = rawCommand.split(' ').last;
      if (TopNavigationData.nameToModeMap.keys.any((it) => it.toLowerCase() == destination)) {
        TopNavigationData.of(context).displayMode =
            TopNavigationData.nameToModeMap[toBeginningOfSentenceCase(destination)]!;
      } else {
        context.pushNamed(destination);
      }
      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('go to');
  }
}
