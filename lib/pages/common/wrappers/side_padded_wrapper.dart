import 'package:flutter/material.dart';

class SidePaddedWidget extends StatelessWidget {
  final Widget child;

  const SidePaddedWidget(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
      child: child,
    );
  }
}
