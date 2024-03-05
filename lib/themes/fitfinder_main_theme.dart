import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FitFinderProTheme {
  FitFinderProTheme._();


  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0x00adb5)),
      fontFamily: GoogleFonts.poppins().fontFamily
    );
  }
}
