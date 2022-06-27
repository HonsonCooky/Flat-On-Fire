import 'package:flutter/material.dart';

abstract class ToastMixin {
  void successToast(String msg, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20.0),
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
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20.0),
        content: Row(
          children: [
            Icon(
              Icons.warning,
              size: 20,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                msg,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void errorToast(String msg, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20.0),
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        children: [
          Icon(
            Icons.error,
            size: 20,
            color: Theme.of(context).colorScheme.onError,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              msg,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

  void devErrorToast(String id, BuildContext context) {
    final s = ScaffoldMessenger.of(context);
    s.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20.0),
      dismissDirection: DismissDirection.horizontal,
      content: Row(
        children: [
          Icon(
            Icons.error,
            size: 20,
            color: Theme.of(context).colorScheme.onError,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Text(
              "The developer of this app did an oopsie\nReference: ${id}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onError,
                  ),
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }
}
