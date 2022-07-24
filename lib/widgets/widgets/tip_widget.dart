import 'package:flutter/material.dart';

class TipWidget extends StatelessWidget {
  final Widget child;
  final String explanation;

  const TipWidget({Key? key, required this.child, required this.explanation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: explanation,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 5),
      padding: const EdgeInsets.all(10),
      child: child,
    );
  }
}
