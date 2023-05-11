import 'package:flutter/src/widgets/framework.dart';
import 'package:lister_app/voice_assist/command.dart';

/// opens the view to create something
class CreateCommand extends Command {
  String subject;

  CreateCommand(super.rawCommand, this.subject);

  @override
  Future defineCommand(BuildContext context) {
    // TODO: implement executeCommand
    throw UnimplementedError();
  }
}