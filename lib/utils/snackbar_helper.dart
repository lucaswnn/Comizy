import 'package:flutter/material.dart';

// Show a snackbar message
// The widget summoner must be a scaffold descendant
class SnackbarHelper {
  const SnackbarHelper._(); // Private constructor to prevent instantiation

  static final _key = GlobalKey<ScaffoldMessengerState>();

  static GlobalKey<ScaffoldMessengerState> get key => _key;

  static void showSnackBar(
    String? message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    _key.currentState
      ?..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          content: Text(message ?? ''),
        ),
      );
  }
}