import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Tuple2<String,Color>?> showListCreationDialog(BuildContext context, String title, String label) async {
  return showDialog<Tuple2<String,Color>>(
      context: context,
      builder: (context) {
        final GlobalKey<FormState> formKey = GlobalKey();
        String name = '';
        Color color = Colors.white;
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelText: label,
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'The text must not be empty';
                            } else {
                              return null;
                            }
                          },
                      onChanged: (text) {
                        name = text;
                      },
                    ),
              const SizedBox(height: 10),
              ColorPicker(
                pickerColor: color,
                onColorChanged: (newColor) {
                  color = newColor;
                },
              ),
              // Use Material color picker:
              //
              // child: MaterialPicker(
              //   pickerColor: pickerColor,
              //   onColorChanged: changeColor,
              //   showLabel: true, // only on portrait mode
              // ),
              //
              // Use Block color picker:
              //
              // child: BlockPicker(
              //   pickerColor: currentColor,
              //   onColorChanged: changeColor,
              // ),
              //
              // child: MultipleChoiceBlockPicker(
              //   pickerColors: currentColors,
              //   onColorsChanged: changeColors,
              // ),
                  ],
                )),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(MaterialLocalizations.of(context).cancelButtonLabel)),
            TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.of(context).pop(Tuple2(name, color));
                  }
                },
                child: Text(MaterialLocalizations.of(context).saveButtonLabel)),
          ],
        );
      });
}