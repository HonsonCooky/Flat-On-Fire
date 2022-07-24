import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextEntryWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? textStyle;
  final TextEditingController? controller;
  final bool editMode;

  const TextEntryWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.textStyle,
    required this.editMode,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool editable = controller != null && editMode;
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        TextField(
          enabled: editable,
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            labelStyle: textStyle?.copyWith(fontWeight: FontWeight.bold),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: value,
            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                  fontSize: textStyle?.fontSize ?? Theme.of(context).inputDecorationTheme.labelStyle?.fontSize,
                  color: editable
                      ? Theme.of(context).inputDecorationTheme.labelStyle?.color
                      : (textStyle?.color ?? Theme.of(context).colorScheme.onSurface),
                ),
          ),
          style: textStyle?.copyWith(fontWeight: FontWeight.normal),
        ),
        controller == null
            ? Material(
                color: Colors.transparent,
                child: IconButton(
                  splashRadius: textStyle?.fontSize ?? Theme.of(context).textTheme.labelMedium?.fontSize ?? 30,
                  splashColor: PaletteAssistant.alpha(Theme.of(context).colorScheme.secondary),
                  iconSize: textStyle?.fontSize,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: value))
                        .then((_) => ToastManager.instance.successToast("Copied Text", Theme.of(context)))
                        .catchError((_) => ToastManager.instance.errorToast("Unable to copy text", Theme.of(context)));
                  },
                  icon: const Icon(Icons.copy),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
