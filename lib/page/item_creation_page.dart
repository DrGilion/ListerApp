import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lister_app/component/feedback.dart';
import 'package:lister_app/component/save_loading_button.dart';
import 'package:lister_app/model/simple_lister_list.dart';
import 'package:lister_app/service/persistence_service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ItemCreationPage extends StatefulWidget {
  static const String routeName = "ItemCreationPage";

  final int? initialListId;

  const ItemCreationPage(this.initialListId, {super.key});

  @override
  _ItemCreationPageState createState() => _ItemCreationPageState();
}

class _ItemCreationPageState extends State<ItemCreationPage> {
  int? listId;
  String? name;
  String description = '';
  bool experienced = false;
  int rating = 0;

  final GlobalKey<FormState> formKey = GlobalKey();
  final _textEditingController = TextEditingController();
  bool isSaving = false;

  final InputDecoration inputDecoration = const InputDecoration();

  List<SimpleListerList> availableLists = [];

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();

    listId = widget.initialListId;

    PersistenceService.of(context).getListsSimple().then((value) {
      value.fold((l) {
        showErrorMessage(context, 'Could not retrieve lists!', l.error, l.stackTrace);
      }, (r) {
        setState(() {
          availableLists = r;
        });
      });
    });

    _initSpeech();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    var locales = await _speechToText.locales();
    print(locales.map((e) => e.localeId).toList());
    await _speechToText.listen(onResult: _onSpeechResult, listenMode: ListenMode.dictation, localeId: 'de_DE');
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
    setState(() {
      _lastWords = result.recognizedWords;
      _textEditingController.text = description + _lastWords;
      if (result.finalResult) {
        description = description + _lastWords;
        _lastWords = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Entry'),
          actions: [
            SaveLoadingButton(
              isSaving: isSaving,
              onPressed: () => _trySave(context),
            )
          ],
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: listId,
                  decoration: inputDecoration.copyWith(labelText: 'List *'),
                  items: availableLists.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(),
                  validator: (item) {
                    if (item == null) {
                      return 'You must choose a list!';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      listId = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  decoration: inputDecoration.copyWith(labelText: 'Name *'),
                  initialValue: name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name must not be empty!';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                    title: const Text("Experienced"),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    value: experienced,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          experienced = value;
                        });
                      }
                    }),
                const SizedBox(height: 10),
                InputDecorator(
                  decoration: inputDecoration.copyWith(labelText: 'Rating', border: InputBorder.none),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: RatingBar.builder(
                      initialRating: rating.toDouble(),
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 10,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (newRating) {
                        setState(() {
                          rating = newRating.toInt();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextFormField(
                    decoration: inputDecoration.copyWith(labelText: 'Description'),
                    maxLines: null,
                    controller: _textEditingController,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
                Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? 'listening...'
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:
              // If not yet listening for speech start, otherwise stop
              _speechToText.isNotListening ? _startListening : _stopListening,
          tooltip: 'Listen',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
    );
  }

  Future<void> _trySave(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isSaving = true;
      });

      await PersistenceService.of(context).createItem(listId!, name!, description, rating, experienced).then((value) {
        value.fold((l) {
          showErrorMessage(context, 'Could not create entry!', l.error, l.stackTrace);
        }, (r) {
          Navigator.of(context).pop(r);
        });
      });

      setState(() {
        isSaving = false;
      });
    }
  }
}
