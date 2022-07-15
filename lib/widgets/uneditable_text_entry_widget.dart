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
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle?.copyWith(
                      fontSize: textStyle?.fontSize,
                      color: textStyle?.color,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              style: textStyle?.copyWith(fontWeight: FontWeight.normal),
            ),
            Material(
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
          ],
        ),
      ],
    );
  }
}
