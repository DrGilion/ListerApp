import 'package:lister_app/voice_assist/command.dart';
import 'package:lister_app/voice_assist/create_command.dart';
import 'package:lister_app/voice_assist/goback_command.dart';
import 'package:lister_app/voice_assist/goto_command.dart';
import 'package:lister_app/voice_assist/open_command.dart';

/// service for handling the commands for voice assistant
class CommandService {
  CommandService._();

  static List<Command> parseTextToCommands(String text){
    print(text);
    final commandStrings = splitCommands(text.toLowerCase());
    print(commandStrings);
    final commands = commandStrings.map((e) => createCommand(e)).toList();
    return commands;
  }

  static List<String> splitCommands(String text){
    return text.split('and').map((e) => e.trim()).toList();
  }

  static Command createCommand(String text){
    if(text.startsWith('create')){
      return CreateCommand(text, text.split(' ').last);
    }

    if(text.startsWith('open')){
      return OpenCommand(text, text.split(' ').last);
    }

    if(text.startsWith('go back')){
      return GoBackCommand(text);
    }

    if(text.startsWith('go to')){
      return GoToCommand(text, text.split(' ').last);
    }

    throw ArgumentError('not a recognized command');
  }
}