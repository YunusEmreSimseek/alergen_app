import 'package:flutter/material.dart';

@immutable
class CustomTheme {
  const CustomTheme._();

  static ThemeData dark =
      ThemeData.dark().copyWith(colorScheme: const ColorScheme.dark().copyWith(primary: Colors.white));

  static ThemeData light =
      ThemeData.light().copyWith(colorScheme: const ColorScheme.light().copyWith(primary: Colors.black));
}
