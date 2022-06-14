import 'package:flutter/painting.dart';

class FofLogoDecoration extends Decoration {
  final Color color;

  const FofLogoDecoration(this.color);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FofLogoPainter(color);
  }
}

class _FofLogoPainter extends BoxPainter {
  final Color color;

  _FofLogoPainter(this.color);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 5;

    var width = configuration.size?.width ?? 100;
    var height = configuration.size?.height ?? 100;

    Path path = Path();
    path.moveTo(width / 2, height / 2);
    path.lineTo(width, height);

    canvas.drawPath(path, paint);
  }
}
