import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TSwitchTheme {
  TSwitchTheme._();

  static SwitchThemeData lightSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? TColors.white : TColors.grey),
    trackColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
            ? TColors.primary
            : TColors.light),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
            ? TColors.primary
            : TColors.grey),
  );

  static SwitchThemeData darkSwitchTheme = SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? TColors.white : TColors.grey),
    trackColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
            ? TColors.primary
            : TColors.dark),
    trackOutlineColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected)
            ? TColors.primary
            : TColors.grey),
  );
}
