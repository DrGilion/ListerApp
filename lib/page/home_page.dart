import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/component/calendar_tab.dart';
import 'package:lister_app/component/lists_tab.dart';
import 'package:lister_app/component/tags_tab.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:lister_app/routing.dart';
import 'package:lister_app/util/flutter_util.dart';
import 'package:lister_app/util/logging.dart';
import 'package:lister_app/viewmodel/display_mode.dart';
import 'package:lister_app/viewmodel/top_navigation_data.dart';
import 'package:lister_app/voice_assist/command_service.dart';
import 'package:lister_app/voice_assist/commandable_mixin.dart';
import 'package:lister_app/voice_assist/commands.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with Commandable, RouteAware {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      routeObserver.subscribe(this, ModalRoute.of(context)!);
    });

    _initSpeech();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);

    super.dispose();
  }

  @override
  void didPush() {
    logger.d('didPush');
    FlutterUtil.globalUnfocus();
  }

  @override
  void didPushNext() {
    logger.d('didPushNext');
    FlutterUtil.globalUnfocus();
  }

  @override
  void didPop() {
    logger.d('didPop');
    FlutterUtil.globalUnfocus();
  }

  @override
  void didPopNext() {
    logger.d('didPopNext');
    FlutterUtil.globalUnfocus();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(onStatus: (newStatus) {
      setState(() {});
    });
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      //get recognized words and turn them into commands
      final commands = CommandService.parseTextToCommands(result.recognizedWords);
      Commands.of(context)
        ..initCommands(commands)
        ..executeCommands(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: _buildBody(context),
            bottomNavigationBar: ConvexAppBar(
              style: TabStyle.react,
              items: [
                TabItem(icon: Icons.home, title: Translations.of(context).lists),
                TabItem(
                    icon: _speechEnabled ? (_speechToText.isNotListening ? Icons.mic_off : Icons.mic) : Icons.close),
                TabItem(icon: Icons.calendar_month, title: Translations.of(context).calendar),
                TabItem(icon: Icons.tag, title: Translations.of(context).tags),
              ],
              onTap: (int index) {
                setState(() {
                  if (index == 0) {
                    TopNavigationData.of(context).displayMode = DisplayMode.lists;
                  } else if (index == 1) {
                    _speechToText.isNotListening ? _startListening() : _stopListening();
                  } else if (index == 2) {
                    TopNavigationData.of(context).displayMode = DisplayMode.calendar;
                  } else if (index == 3) {
                    TopNavigationData.of(context).displayMode = DisplayMode.tags;
                  }
                });
              },
            )));
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<TopNavigationData>(
      builder: (context, data, _) {
        return switch (data.displayMode) {
          DisplayMode.lists => const ListsTab(),
          DisplayMode.calendar => const CalendarTab(),
          DisplayMode.tags => const TagsTab(),
        };
      },
    );
  }
}
