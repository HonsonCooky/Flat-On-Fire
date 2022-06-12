import 'package:flutter/material.dart';

import 'fof_button_style.dart';
import 'fof_custom_colors.dart';

FofButtonStyle primaryButtonStyle(BuildContext context) {
  FofCustomColors fcc = Theme.of(context).extension<FofCustomColors>()!;
  return FofButtonStyle(ColorAlter.lighten(fcc.primary), fcc.primary, fcc.background, 0, 10);
}

FofButtonStyle googleBlueButtonStyle(BuildContext context) {
  FofCustomColors fcc = Theme.of(context).extension<FofCustomColors>()!;
  return FofButtonStyle(ColorAlter.lighten(fcc.googleBlue), fcc.googleBlue, fcc.background, 0, 10);
}

FofButtonStyle textButtonStyle(BuildContext context) {
  FofCustomColors fcc = Theme.of(context).extension<FofCustomColors>()!;
  return FofButtonStyle(ColorAlter.alpha(ColorAlter.lighten(fcc.primary), .1), null, fcc.primary, 0, 20);
}
