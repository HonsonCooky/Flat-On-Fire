import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UneditableTextEntryWidget extends StatelessWidget with ToastMixin {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyle?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: PaletteAssistant.alpha(textStyle?.color ?? Colors.black, 0.4),
                ),
              ),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: textStyle?.fontSize,
              iconSize: textStyle?.fontSize,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value)).then((value) => successToast("Copied Text", context));
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
      ],
    );
  }
}
