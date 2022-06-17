import 'package:flat_on_fire/common_widgets/logo/fof_logo_decoration.dart';
import 'package:flutter/material.dart';

class FofLogo extends StatelessWidget {
  final Color? color;
  final Offset? offset;
  final double? size;
  final Duration duration;
  final Curve curve;

  const FofLogo({
    Key? key,
    this.color,
    this.offset,
    this.size,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      decoration: FofLogoDecoration(
        color ?? Theme.of(context).colorScheme.background,
        offset,
        size,
      ),
    );
  }
}
