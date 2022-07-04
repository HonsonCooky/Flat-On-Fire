import 'package:flutter/material.dart';

abstract class ToastMixin {
  void successToast(String msg, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        content: Text(
          msg,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void infoToast(String msg, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        content: Text(
          msg,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void errorToast(String msg, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        dismissDirection: DismissDirection.horizontal,
        content: Text(
          msg,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void devErrorToast(String id, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.fixed,
        dismissDirection: DismissDirection.horizontal,
        content: Text(
          "The developer of this app did an oopsie\nReference: ${id}",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onError,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }
}
