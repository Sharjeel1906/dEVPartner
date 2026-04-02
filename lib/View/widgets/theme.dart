import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class C {
  static const Color bg = Color(0xFF060814);
  static const Color surface = Color(0x0AFFFFFF); // 0.04 opacity
  static const Color surfaceHover = Color(0x12FFFFFF); // 0.07 opacity
  static const Color border = Color(0x17FFFFFF); // 0.09 opacity
  static const Color borderFocus = Color(0x8000F5A0); // 0.5 opacity

  static const Color green = Color(0xFF00F5A0);
  static const Color cyan = Color(0xFF00D9F5);
  static const Color pink = Color(0xFFFF1EB0);
  static const Color amber = Color(0xFFF5A500);
  static const Color blue = Color(0xFF02BBFF);
  static const Color purple = Color(0xFFA78BFA);
  static const Color orange = Color(0xFFF97316);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0x66FFFFFF); // 0.4 opacity
  static const Color textLabel = Color(0x99FFFFFF); // 0.6 opacity
}

// Global Theme Data
ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: C.bg,
  textTheme: TextTheme(
    displayLarge: GoogleFonts.getFont('Space Mono', color: C.textPrimary),
    bodyLarge: GoogleFonts.getFont('DM Sans', color: C.textPrimary),
    bodyMedium: GoogleFonts.getFont('DM Sans', color: C.textLabel),
  ),
);