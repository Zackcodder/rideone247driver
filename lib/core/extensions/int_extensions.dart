import 'package:flutter/material.dart';

extension IntExtensions on int {
  ThemeMode get toThemeMode => this == 0 ? ThemeMode.light : ThemeMode.dark;

  String get formatedHour {
    if (this == 12) {
      return '12 PM';
    } else if (this == 24) {
      return '0 AM';
    }
    if (this > 11 && this < 24) {
      return '${this - 12} PM';
    } else {
      return '$this AM';
    }
  }

  Duration get ms => Duration(milliseconds: this);
  Duration get s => Duration(seconds: this);
  Duration get m => Duration(minutes: this);
}
