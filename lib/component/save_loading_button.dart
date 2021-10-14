import 'package:flutter/material.dart';

class SaveLoadingButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveLoadingButton({Key? key, required this.isSaving, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSaving
          ? SizedBox(
              width: IconTheme.of(context).size,
              height: IconTheme.of(context).size,
              child: const CircularProgressIndicator(color: Colors.white))
          : Icon(Icons.save),
      tooltip: 'Save',
      onPressed: onPressed,
    );
  }
}
