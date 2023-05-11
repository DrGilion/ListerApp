import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/voice_assist/command.dart';

/// Navigate to a specific place in the application
class GoToCommand extends Command<void> {
  String destination;

  GoToCommand(super.rawCommand, this.destination);

  @override
  Future defineCommand(BuildContext context) {
    context.pushNamed(destination);
    return Future.value();
  }
}