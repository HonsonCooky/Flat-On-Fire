import 'package:flutter/material.dart';

class FullImageDialogWidget extends StatelessWidget {
  final Image image;
  final String title;

  const FullImageDialogWidget({Key? key, required this.image, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        title: Text(title),
        content: image,
        actions: [
          _cancelButton(context),
        ],
      ),
    );
  }

  // set up the buttons
  Widget _cancelButton(BuildContext context) {
    return TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
