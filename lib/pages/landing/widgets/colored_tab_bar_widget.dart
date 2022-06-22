import 'package:flutter/material.dart';

class ColoredTabBar extends StatelessWidget {
  final TabBar tabBar;

  const ColoredTabBar({Key? key, required this.tabBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: tabBar,
    );
  }
}
