import 'package:flutter/material.dart';
import 'package:lister_app/util/logging.dart';

void showErrorMessage(BuildContext context, String message, dynamic error, StackTrace stackTrace) {
  logger.e(message, error, stackTrace);
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(message, style: const TextStyle(color: Colors.white))));
}
