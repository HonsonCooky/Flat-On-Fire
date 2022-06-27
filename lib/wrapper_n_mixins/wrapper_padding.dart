import 'package:flutter/material.dart';

class WrapperPadding extends StatelessWidget {
  final Widget child;

  const WrapperPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
      child: Center(child: child),
    );
  }
}