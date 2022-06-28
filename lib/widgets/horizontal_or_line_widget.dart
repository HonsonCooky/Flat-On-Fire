import 'package:flutter/material.dart';

class HorizontalOrLineWidget extends StatelessWidget {
  final String label;
  final double padding;
  final Color color;

  const HorizontalOrLineWidget({
    Key? key,
    required this.label,
    required this.padding,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(right: 15),
            child: Divider(
              color: color,
              height: padding,
              thickness: 1.5,
            )),
      ),
      Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: color),
      ),
      Expanded(
        child: Container(
            margin: const EdgeInsets.only(left: 15),
            child: Divider(
              color: color,
              height: padding,
              thickness: 1.5,
            )),
      ),
    ]);
  }
}
