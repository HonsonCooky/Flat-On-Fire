import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteAccountAlertWidget extends StatefulWidget {
  const DeleteAccountAlertWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DeleteAccountAlertWidgetState();
}

class _DeleteAccountAlertWidgetState extends State<DeleteAccountAlertWidget> {
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
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _deleteButton() {
    return TextButton(
      child: Text(
        "Delete my account",
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.onError),
      ),
      onPressed: () async {
        Navigator.of(context).pop();
        var theme = Theme.of(context); // Get before async gap
        var deleteText = await context.read<AuthService>().deleteAccount();
        if (deleteText != AuthService.successfulOperation) {
          ToastManager.instance.errorToast(deleteText, theme);
        }
      },
    );
  }
}
