import 'package:flutter/material.dart';

abstract class Command<T> {
  String rawCommand;

  Command(this.rawCommand);

  Future<T> executeCommand(BuildContext context) {
    print("Executing command: $rawCommand");
    return defineCommand(context);
  }

  Future<T> defineCommand(BuildContext context);
}