import 'package:flutter/cupertino.dart';
import 'package:lister_app/voice_assist/command.dart';
import 'package:provider/provider.dart';

class Commands {
  static Commands of(BuildContext context) => Provider.of<Commands>(context, listen: false);
  List<Command> commands = [];
  int currentCommandIndex = 0;
  dynamic lastResult;

  bool get commandsLeft => currentCommandIndex < commands.length;

  void initCommands(List<Command> commands) {
    currentCommandIndex = 0;
    lastResult = null;
    this.commands = commands;
  }

  /// executes the command next in line
  Future<void> executeCommands(BuildContext context) async {
    if(commandsLeft){
      lastResult = await commands[currentCommandIndex].executeCommand(context);
      currentCommandIndex++;
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
