import 'package:flutter/material.dart';
import 'package:lister_app/voice_assist/command.dart';
import 'package:lister_app/voice_assist/create_command.dart';
import 'package:lister_app/voice_assist/goback_command.dart';
import 'package:lister_app/voice_assist/goto_command.dart';
import 'package:lister_app/voice_assist/open_command.dart';
import 'package:lister_app/voice_assist/switch_list_command.dart';

/// service for handling the commands for voice assistant
class CommandService {
  CommandService._();

  static List<Command> availableCommands = [
    CreateCommand(),
    GoToCommand(),
    GoBackCommand(),
    OpenCommand(),
    SwitchListCommand(),
  ];

  static List<Future Function(BuildContext)> parseTextToCommands(String text) {
    print(text);
    final commandStrings = splitCommands(text.toLowerCase());
    print(commandStrings);
    final commands = commandStrings.map((e) => createCommand(e)).toList();
    return commands;
  }

  static List<String> splitCommands(String text) {
    return text.split('and').map((e) => e.trim()).toList();
  }

  static Future Function(BuildContext) createCommand(String text) {
    return availableCommands
        .firstWhere((command) => command.matchesCommand(text),
            orElse: () => throw ArgumentError('not a recognized command'))
        .generateCommand(text);
  }
}
