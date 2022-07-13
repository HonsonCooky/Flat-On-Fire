import 'package:flutter/material.dart';

class ToastManager {
  final int _snackbarDuration = 2000;
  final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  ToastManager._privateConstructor();

  static final ToastManager instance = ToastManager._privateConstructor();

  void successToast(String msg, ThemeData theme) {
    if (rootScaffoldMessengerKey.currentState == null) return;
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
          duration: Duration(milliseconds: _snackbarDuration),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          content: Text(
            msg,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary),
          ),
          backgroundColor: theme.colorScheme.primary),
    );
  }

  void infoToast(String msg, ThemeData theme) {
    if (rootScaffoldMessengerKey.currentState == null) return;
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
          duration: Duration(milliseconds: _snackbarDuration),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          content: Text(
            msg,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface),
          ),
          backgroundColor: theme.colorScheme.surface),
    );
  }

  void errorToast(String msg, ThemeData theme) {
    if (rootScaffoldMessengerKey.currentState == null) return;
    rootScaffoldMessengerKey.currentState!.showSnackBar(
      SnackBar(
          duration: Duration(milliseconds: _snackbarDuration),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.horizontal,
          content: Text(
            msg,
            style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onError),
          ),
          backgroundColor: theme.colorScheme.error),
    );
  }
}
