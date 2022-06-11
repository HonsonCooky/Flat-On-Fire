import 'package:flat_on_fire/theme_consistency_components/objects/fof_buttons/fof_button_style.dart';
import 'package:flat_on_fire/theme_consistency_components/objects/fof_custom_colors.dart';
import 'package:flutter/material.dart';

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