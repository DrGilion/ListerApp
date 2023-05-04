import 'package:flutter/material.dart';

class SaveLoadingButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback onPressed;

  const SaveLoadingButton({super.key, required this.isSaving, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: isSaving
          ? SizedBox(
              width: IconTheme.of(context).size,
              height: IconTheme.of(context).size,
              child: const CircularProgressIndicator(color: Colors.white))
          : const Icon(Icons.save),
      tooltip: 'Save',
      onPressed: onPressed,
    );
  }
}
