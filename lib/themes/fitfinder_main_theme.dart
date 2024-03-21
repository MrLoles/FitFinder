import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FitFinderProTheme {
  FitFinderProTheme._();

  static ThemeData buildTheme() {
    return ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFF4dc6cb), // Ustawienie koloru tła AppBar
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontSize: 20,
            )),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        fontFamily: GoogleFonts.poppins().fontFamily);
  }
}
