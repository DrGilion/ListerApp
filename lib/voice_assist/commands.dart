import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class Commands extends ChangeNotifier{
  static Commands of(BuildContext context) => Provider.of<Commands>(context, listen: false);
  List<Future Function(BuildContext)> commands = [];
  int currentCommandIndex = 0;
  dynamic lastResult;

  bool get commandsLeft => currentCommandIndex < commands.length;

  void initCommands(List<Future Function(BuildContext)> commands) {
    currentCommandIndex = 0;
    lastResult = null;
    this.commands = commands;
  }

  /// executes the command next in line
  Future<void> executeCommands(BuildContext context) async {
    if(commandsLeft){
      lastResult = await commands[currentCommandIndex](context);
      currentCommandIndex++;
      await Future.delayed(const Duration(seconds: 1));
      notifyListeners();
    }
  }
}
