import 'package:flutter/material.dart';

extension ThemeModeExtensions on ThemeMode {
  int get toInt => this == ThemeMode.light ? 0 : 1;
}



