import 'package:flutter/material.dart';
import 'package:lister_app/voice_assist/commands.dart';

mixin Commandable<T extends StatefulWidget> on State<T> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final commands = Commands.of(context);
          commands.executeCommands(context);
    });
  }
}