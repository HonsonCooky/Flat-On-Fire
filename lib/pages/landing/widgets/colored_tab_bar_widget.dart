import 'package:flutter/material.dart';

class ColoredTabBarWidget extends StatelessWidget {
  final TabBar tabBar;

  const ColoredTabBarWidget({Key? key, required this.tabBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: tabBar,
    );
  }
}
