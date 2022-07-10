import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class BooleanSwitcherWidget extends StatelessWidget {
  final String title;
  final List<String> hints;
  final bool isOn;
  final String explanation;
  final void Function(bool)? onChanged;
  final TextStyle? textStyle;

  const BooleanSwitcherWidget({
    Key? key,
    required this.title,
    required this.hints,
    required this.isOn,
    required this.explanation,
    this.onChanged,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(hints.length == 2);
    return TipWidget(
      explanation: explanation,
      child: SwitchListTile(
        title: Row(
          children: [
            Text(
              title,
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Text(
                isOn ? hints[0] : hints[1],
                style: textStyle?.copyWith(fontWeight: FontWeight.normal),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        value: isOn,
        onChanged: onChanged,
      ),
    );
  }
}
