import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/voice_assist/commands.dart';

mixin Commandable<T extends StatefulWidget> on State<T> {
  late VoidCallback changeListener;
  late Commands commands;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      commands = Commands.of(context);
      commands.addListener(changeListener = () {
        //print('we are in ${ModalRoute.of(context)?.settings.name} ${router.routeConfiguration.routes.whereType<GoRoute>().firstWhere((element) => element.name == ModalRoute.of(context)?.settings.name).path}');
        //print('top path is ${ModalRoute.of(navigatorKey.currentContext!)?.settings.name} ${GoRouter.of(context).location}');
        final thisPath = router.routeConfiguration.routes.whereType<GoRoute>().firstWhere((element) => element.name == ModalRoute.of(context)?.settings.name).path;
        final currentPath = GoRouter.of(context).location;
        if(thisPath == currentPath){
          commands.executeCommands(context);
        }
      });
    });
  }

  @override
  void dispose() {
    commands.removeListener(changeListener);
    super.dispose();
  }
}
