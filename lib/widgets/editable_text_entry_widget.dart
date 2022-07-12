import 'package:flutter/material.dart';

class EditableTextEntryWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextEditingController controller;
  final TextStyle? textStyle;

  const EditableTextEntryWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.controller,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            contentPadding: const EdgeInsets.all(5),
          ),
          style: textStyle?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
