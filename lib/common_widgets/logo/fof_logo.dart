import 'package:flat_on_fire/common_widgets/logo/fof_logo_decoration.dart';
import 'package:flutter/material.dart';

class FofLogo extends StatelessWidget {
  final double? size;
  final Color? color;
  final Duration duration;
  final Curve curve;

  const FofLogo({
    Key? key,
    this.size,
    this.color,
    this.duration = const Duration(milliseconds: 750),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double? iconSize = size ?? iconTheme.size;
    return AnimatedContainer(
      width: iconSize,
      height: iconSize,
      duration: duration,
      curve: curve,
      decoration: FofLogoDecoration(color ?? Theme.of(context).colorScheme.background),
    );
  }
}
