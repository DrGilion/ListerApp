import 'package:flutter/material.dart';
import 'package:lister_app/generated/l10n.dart';

Future<String?> showTextFieldDialog(BuildContext context, String title, String label,
    {String? initialValue, String? Function(String?)? customValidator}) async {
  return showDialog<String>(
      context: context,
      builder: (context) {
        final GlobalKey<FormState> formKey = GlobalKey();
        String? name = initialValue;
        return AlertDialog(
          title: Text(title),
          content: Form(
              key: formKey,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: label,
                ),
                initialValue: name,
                validator: customValidator ??
                    (value) {
                      if (value == null || value.isEmpty) {
                        return Translations.of(context).validation_empty;
                      } else {
                        return null;
                      }
                    },
                onChanged: (text) {
                  name = text;
                },
              )),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop(name);
                  }
                },
                child: Text(MaterialLocalizations.of(context).saveButtonLabel)),
          ],
        );
      });
}
