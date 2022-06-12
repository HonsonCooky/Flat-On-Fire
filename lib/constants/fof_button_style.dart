import 'package:flutter/material.dart';

/// A button style which takes values and handles the necessary 'MaterialStateProperty' resolutions.
class FofButtonStyle extends ButtonStyle {
  final Color _overlay;
  final Color? _background;
  final Color? _foreground;
  final double _paddingHorizontal;
  final double _paddingVertical;

  const FofButtonStyle(
      this._overlay, this._background, this._foreground, this._paddingHorizontal, this._paddingVertical);

  FofButtonStyle factory({
    Color? overlay,
    Color? background,
    Color? foreground,
    double? paddingHorizontal,
    double? paddingVertical,
  }) {
    return FofButtonStyle(overlay ?? _overlay, background ?? _background, foreground ?? _foreground,
        paddingHorizontal ?? _paddingHorizontal, paddingVertical ?? _paddingVertical);
  }

  @override
  get elevation => MaterialStateProperty.resolveWith<double?>((Set<MaterialState> states) {
        if (_background == null) return 0;
        if (states.contains(MaterialState.pressed)) {
          return 1;
        }
        return 5;
      });

  @override
  get overlayColor => MaterialStateProperty.resolveWith<Color?>((states) => _overlay);

  @override
  get backgroundColor => MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => _background);

  @override
  get foregroundColor => MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) => _foreground);

  @override
  get padding => MaterialStateProperty.resolveWith<EdgeInsetsGeometry?>(
      (states) => EdgeInsets.symmetric(horizontal: _paddingHorizontal, vertical: _paddingVertical));
}
