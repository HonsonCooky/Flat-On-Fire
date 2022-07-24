import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountDialogWidget extends StatefulWidget {
  const DeleteAccountDialogWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeleteAccountDialogWidgetState();
}

class _DeleteAccountDialogWidgetState extends State<DeleteAccountDialogWidget> {
  @override
  Widget build(BuildContext context) {
    // set up the AlertDialog
    return AlertDialog(
      title: const Text("Warning"),
      content: const Text("Are you sure you want to permanently delete your account and all it's information?"),
      actions: [
        _deleteButton(),
        _cancelButton(),
      ],
    );
  }

  // set up the buttons
  Widget _cancelButton() {
    return TextButton(
      child: const Text("CANCEL"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _deleteButton() {
    return ElevatedButton(
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            backgroundColor: MaterialStateProperty.resolveWith((states) => Theme.of(context).colorScheme.onError),
          ),
      onPressed: () async {
        Navigator.of(context).pop();
        var theme = Theme.of(context); // Get before async gap
        var deleteText = await context.read<AuthService>().deleteAccount();
        if (deleteText != AuthService.successfulOperation) {
          ToastManager.instance.errorToast(deleteText, theme);
        }
      },
      child: Text(
        "DELETE MY ACCOUNT",
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
