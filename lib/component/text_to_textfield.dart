import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class TextToTextField extends StatefulWidget {
  final String label;
  final String? initialText;
  final bool bigbox;
  final TextInputType? customInputType;
  final Future<bool> Function(String) onSave;

  const TextToTextField(
      {super.key,
      required this.label,
      this.initialText,
      this.bigbox = false,
      this.customInputType,
      required this.onSave});

  @override
  _TextToTextFieldState createState() => _TextToTextFieldState();
}

class _TextToTextFieldState extends State<TextToTextField> {
  bool _isEditingText = false;
  late TextEditingController _editingController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.initialText ?? '');
    _focusNode.addListener(_onFocusNodeListener);
  }

  @override
  void dispose() {
    _editingController.dispose();
    _focusNode.removeListener(_onFocusNodeListener);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildInput(),
        _buildButtons(),
      ],
    );
  }

  Widget _buildInput() {
    return _isEditingText
        ? Expanded(
            child: TextField(
              focusNode: _focusNode,
              controller: _editingController,
              minLines: widget.bigbox ? 3 : 1,
              maxLines: widget.bigbox ? null : 1,
              autofocus: true,
              keyboardType: widget.customInputType,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: const TextStyle(color: Colors.grey),
              ),
              onSubmitted: (newValue) {
                _save();
              },
            ),
          )
        : Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: widget.bigbox ? null : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Linkify(
                    text: widget.initialText != null && widget.initialText!.isNotEmpty ? widget.initialText! : '',
                    style: const TextStyle(color: Colors.black, fontSize: 18.0),
                    options: const LinkifyOptions(humanize: false),
                    onOpen: (link) async {
                      if (await canLaunchUrl(Uri.parse(link.url))) {
                        await launchUrl(Uri.parse(link.url));
                      } else {
                        throw 'Could not launch $link';
                      }
                    })
              ],
            ),
          );
  }

  Widget _buildButtons() {
    return _isEditingText
        ? Row(
            children: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                tooltip: MaterialLocalizations.of(context).saveButtonLabel,
                onPressed: _save,
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                tooltip: MaterialLocalizations.of(context).cancelButtonLabel,
                onPressed: _cancel,
              )
            ],
          )
        : IconButton(icon: const Icon(Icons.edit, color: Colors.grey), tooltip: 'Edit', onPressed: _edit);
  }

  void _edit() {
    setState(() {
      _isEditingText = true;
      _focusNode.requestFocus();
    });
  }

  Future<void> _save() async {
    bool success = await widget.onSave(_editingController.text);
    setState(() {
      _isEditingText = false;
      if (!success) _editingController.text = widget.initialText!;
    });
  }

  void _cancel() {
    setState(() {
      _isEditingText = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editingController.text = widget.initialText ?? '';
    });
  }

  void _onFocusNodeListener() {
    if (!_focusNode.hasFocus) _cancel();
  }
}
