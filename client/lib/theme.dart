import 'package:flutter/material.dart';

const Color primaryColor = const Color(0xFF5E6CE7);

const TabBarTheme _tabBarTheme = const TabBarTheme(
  indicator: const BoxDecoration(
    border: const Border(bottom: const BorderSide(color: primaryColor)),
  ),
  indicatorSize: TabBarIndicatorSize.label,
);

class AppTheme {
  const AppTheme._();

  static ThemeData light() =>  ThemeData(
        visualDensity: ThemeData.light().visualDensity,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        primaryColorBrightness: Brightness.light,
        appBarTheme: const AppBarTheme(color: Colors.white, elevation: 0),
        tabBarTheme: _tabBarTheme,
      );

  static ThemeData dark() => ThemeData
      .dark()
      .copyWith(
        primaryColor: primaryColor,
        appBarTheme: const AppBarTheme(color: Colors.black, elevation: 0),
        tabBarTheme: _tabBarTheme,
      );
}
