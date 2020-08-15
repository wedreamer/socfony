import 'package:flutter/material.dart';

const Color primaryColor = const Color(0xFF5E6CE7);

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
    );
  }

  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
    );
  }
}
