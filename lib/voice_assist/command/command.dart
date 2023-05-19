import 'package:flutter/material.dart';

abstract class Command<T> {
  /// Does the given text match the syntax of the command?
  bool matchesCommand(String text);

  /// actual definition of the command
  Future<T> Function(BuildContext) generateCommand(String rawCommand);
}