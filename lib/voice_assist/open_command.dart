import 'package:flutter/material.dart';
import 'package:lister_app/model/lister_item.dart';
import 'package:lister_app/voice_assist/command.dart';

/// navigates to the detail view of something e.g. a [ListerItem]
class OpenCommand extends Command<void> {
  String subject;

  OpenCommand(super.rawCommand, this.subject);

  @override
  Future defineCommand(BuildContext context) {
    // TODO: implement executeCommand
    throw UnimplementedError();
  }
}