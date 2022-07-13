import 'package:flutter/material.dart';

class WrapperFocusShift extends StatelessWidget {
  final Widget child;
  final void Function()? extraFunction;

  const WrapperFocusShift({required this.child, this.extraFunction, Key? key}) : super(key: key);

  void _removeFocus() {
    if (extraFunction != null) extraFunction!();
    if (FocusManager.instance.primaryFocus?.hasFocus ?? false) FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _removeFocus(),
      child: child,
    );
  }
}
