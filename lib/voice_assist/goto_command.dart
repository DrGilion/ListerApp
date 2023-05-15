import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/voice_assist/command.dart';

/// Navigate to a specific place in the application
class GoToCommand extends Command<void> {

  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context){
      final destination = rawCommand.split(' ').last;
      context.pushNamed(destination);
      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('go to');
  }
}