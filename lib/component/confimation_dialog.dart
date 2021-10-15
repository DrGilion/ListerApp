import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(BuildContext context, String header, String content) async {
  return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(header),
              content: Text(content),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            );
          }) ??
      false;
}
