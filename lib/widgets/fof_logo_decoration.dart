import 'package:flutter/material.dart';

class FofLogoDecoration extends Decoration {
  final Color color;
  final Offset? offset;
  final double? size;

  const FofLogoDecoration({required this.color, this.offset, this.size});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FofLogoPainter(color, offset, size);
  }
}

class _FofLogoPainter extends BoxPainter {
  final Color color;
  final Offset? offset;
  final double? size;

  _FofLogoPainter(this.color, this.offset, this.size);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);

    var icon = Icons.perm_contact_calendar_rounded;
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size ?? configuration.size?.height,
        fontFamily: icon.fontFamily,
        color: color,
      ),
    );

    textPainter.layout();
    textPainter.paint(
        canvas,
        Offset(
          offset.dx + (this.offset?.dx ?? 0),
          offset.dy + (this.offset?.dy ?? 0),
        ));
  }
}
