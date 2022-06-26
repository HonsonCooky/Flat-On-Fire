import 'package:flutter/material.dart';

class WrapperFocusShift extends StatelessWidget {
  final Widget child;
  final void Function()? extraFunction;

  const WrapperFocusShift({required this.child, this.extraFunction, Key? key}) : super(key: key);

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
