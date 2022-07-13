import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UneditableTextEntryWidget extends StatelessWidget {
  final String title;
  final String value;
  final TextStyle? textStyle;

  const UneditableTextEntryWidget({
    Key? key,
    required this.title,
    required this.value,
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
        Stack(
          alignment: Alignment.centerRight,
          children: [
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: value,
                hintStyle: textStyle?.copyWith(
                  color: PaletteAssistant.alpha(textStyle?.color ?? Theme.of(context).colorScheme.onSurface),
                ),
                contentPadding: const EdgeInsets.all(5).copyWith(right: (textStyle?.fontSize ?? 10) * 3),
              ),
              style: textStyle?.copyWith(fontWeight: FontWeight.normal),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: textStyle?.fontSize,
              iconSize: textStyle?.fontSize,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value))
                    .then((_) => ToastManager.instance.successToast("Copied Text", Theme.of(context)))
                    .catchError((_) => ToastManager.instance.errorToast("Unable to copy text", Theme.of(context)));
              },
              icon: const Icon(Icons.copy),
            )
          ],
        ),
      ],
    );
  }
}
