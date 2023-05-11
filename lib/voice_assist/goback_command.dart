import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/voice_assist/command.dart';

/// Navigate to a specific place in the application
class GoBackCommand extends Command<void> {

  GoBackCommand(super.rawCommand);

  @override
  Future defineCommand(BuildContext context) {
    context.pop();
    return Future.value();
  }
}