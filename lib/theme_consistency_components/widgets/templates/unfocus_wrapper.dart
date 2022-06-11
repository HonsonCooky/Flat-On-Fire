import 'package:flutter/material.dart';

/// A component wrapper which removes focus from components on tap. Usually used as a wrapper for pages, such that on
/// tapping away from a text field, the keyboard is dismissed.
class UnFocusWrapper extends StatelessWidget {
  final Widget child;
  final void Function()? extraFunction;

  const UnFocusWrapper({required this.child, this.extraFunction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (extraFunction != null) extraFunction!();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
