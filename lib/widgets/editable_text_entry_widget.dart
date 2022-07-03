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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: textStyle?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
