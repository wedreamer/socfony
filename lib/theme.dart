import 'package:fans/widgets/custom-underline-tab-indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryColor = const Color(0xFF5E6CE7);

final TextTheme _textTheme = TextTheme(
  headline1: GoogleFonts.roboto(
    fontSize: 96,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  headline2: GoogleFonts.roboto(
    fontSize: 60,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  headline3: GoogleFonts.roboto(
    fontSize: 48,
    fontWeight: FontWeight.w400,
  ),
  headline4: GoogleFonts.roboto(
    fontSize: 34,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  headline5: GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.w400,
  ),
  headline6: GoogleFonts.roboto(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  subtitle1: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  ),
  subtitle2: GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  ),
  bodyText1: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyText2: GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  button: GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  caption: GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  overline: GoogleFonts.roboto(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);

final TabBarTheme _tabBarTheme = TabBarTheme(
  labelColor: primaryColor,
  unselectedLabelColor: Colors.black87,
  indicator: CustomUnderlineTabIndicator(
    borderSide: BorderSide(
      color: primaryColor,
      width: 3.0,
    ),
    insets: EdgeInsets.only(bottom: 4.0),
  ),
  indicatorSize: TabBarIndicatorSize.label,
);

final BottomNavigationBarThemeData _bottomNavigationBarTheme =
    BottomNavigationBarThemeData(
  type: BottomNavigationBarType.fixed,
  selectedItemColor: primaryColor,
);

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    final TextTheme textTheme = _textTheme.apply(bodyColor: Colors.white);
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: Colors.black,
        brightness: Brightness.dark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        textTheme: textTheme,
      ),
      tabBarTheme: _tabBarTheme.copyWith(
        unselectedLabelColor: Colors.white,
      ),
      textTheme: textTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }

  static ThemeData light() {
    final TextTheme textTheme = _textTheme.apply(bodyColor: Colors.black);
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        brightness: Brightness.light,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        textTheme: textTheme,
      ),
      tabBarTheme: _tabBarTheme,
      textTheme: textTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
    );
  }
}
