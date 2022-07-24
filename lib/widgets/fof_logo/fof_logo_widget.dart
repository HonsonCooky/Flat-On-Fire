import 'package:flat_on_fire/_app_bucket.dart';
import 'package:flutter/material.dart';

class FofLogoWidget extends StatelessWidget {
  final Color? color;
  final Offset? offset;
  final double? size;

  const FofLogoWidget({
    Key? key,
    this.color,
    this.offset,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: FofLogoDecoration(
        color: color ?? Theme.of(context).colorScheme.background,
        offset: offset,
        size: size,
      ),
    );
  }
}
