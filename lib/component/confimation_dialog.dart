import 'package:flutter/material.dart';
import 'package:lister_app/generated/l10n.dart';

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
                  child: Text(Translations.of(context).no),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text(Translations.of(context).yes),
                ),
              ],
            );
          }) ??
      false;
}
