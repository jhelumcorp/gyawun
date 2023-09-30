import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ShowSnackBar {
  static void showSnackBar(
    BuildContext context,
    String title, {
    SnackBarAction? action,
    Duration duration = const Duration(seconds: 1),
    bool noAction = false,
    Color? backgroundColor,
  }) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: duration,
          elevation: 6,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          content: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          action: noAction
              ? null
              : action ??
                  SnackBarAction(
                    textColor: Theme.of(context).colorScheme.secondary,
                    label: 'ok',
                    onPressed: () {},
                  ),
        ),
      );
    } catch (e) {
      Logger.root.severe('Failed to show Snackbar with title: $title', e);
    }
  }

  static void showSuccess(BuildContext context, String title,
          {SnackBarAction? action,
          Duration duration = const Duration(seconds: 1),
          bool noAction = false}) =>
      showSnackBar(context, title,
          action: action,
          duration: duration,
          noAction: noAction,
          backgroundColor: Colors.green);
  static void showError(BuildContext context, String title,
          {SnackBarAction? action,
          Duration duration = const Duration(seconds: 1),
          bool noAction = false}) =>
      showSnackBar(context, title,
          action: action,
          duration: duration,
          noAction: noAction,
          backgroundColor: Colors.red);
  static void showWarning(BuildContext context, String title,
          {SnackBarAction? action,
          Duration duration = const Duration(seconds: 1),
          bool noAction = false}) =>
      showSnackBar(context, title,
          action: action,
          duration: duration,
          noAction: noAction,
          backgroundColor: Colors.yellow);
}
