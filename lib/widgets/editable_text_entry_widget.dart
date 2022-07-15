import 'package:flutter/material.dart';

class EditableTextEntryWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextEditingController controller;
  final TextStyle? textStyle;
  final bool visible;

  const EditableTextEntryWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.controller,
    required this.textStyle,
    this.visible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: (textStyle?.fontSize ?? 10) - 2),
        ),
        const SizedBox(height: 5),
        TextField(
          obscureText: !visible,
          controller: controller,
          decoration: InputDecoration(
            hintText: value,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(fontSize: textStyle?.fontSize),
          ),
          style: textStyle?.copyWith(fontSize: textStyle?.fontSize, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
