import 'package:flutter/material.dart';
import 'package:lister_app/voice_assist/command.dart';

/// opens the view to create something
class CreateCommand extends Command<void> {

  @override
  Future Function(BuildContext) generateCommand(String rawCommand) {
    return (context){

      return Future.value();
    };
  }

  @override
  bool matchesCommand(String text) {
    return text.startsWith('create');
  }
}