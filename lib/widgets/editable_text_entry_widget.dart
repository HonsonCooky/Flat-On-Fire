import 'package:flutter/material.dart';

class EditableTextEntryWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextEditingController controller;
  final TextStyle? textStyle;
  final bool visible;
  final bool editMode;

  const EditableTextEntryWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.controller,
    required this.textStyle,
    this.visible = true,
    this.editMode = false,
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
          obscureText: !visible,
          controller: controller,
          enabled: editMode,
          decoration: InputDecoration(
            hintText: value,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                  fontSize: textStyle?.fontSize,
                  color: editMode
                      ? Theme.of(context).inputDecorationTheme.labelStyle?.color
                      : Theme.of(context).colorScheme.onSurface,
                ),
          ),
          style: textStyle?.copyWith(fontSize: textStyle?.fontSize, fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
