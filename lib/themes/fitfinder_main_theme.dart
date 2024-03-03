import 'package:flutter/material.dart';

class FitFinderProTheme {
  FitFinderProTheme._();


  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    );
  }
}
