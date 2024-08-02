import 'package:flutter/material.dart';

import 'common/config.dart';

ThemeData kampoTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color(0xFF7890C8),
    secondary: const Color(0xFFB6ADDE),
  ),
  canvasColor: Colors.grey[100],
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme: const AppBarTheme(
    backgroundColor: KampoColors.primary,
    centerTitle: true,
  ),
  dividerTheme: const DividerThemeData(color: Colors.transparent),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
    filled: true,
    border: InputBorder.none,
    errorStyle: TextStyle(color: Colors.red),
  ),
);
