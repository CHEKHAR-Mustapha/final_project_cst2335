import 'package:flutter/material.dart';

/// A utility class for displaying custom snackbars.
class CustomSnackbar {
  /// Displays a custom snackbar with the given message.
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blueGrey,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}