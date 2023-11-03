import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  // Theme Extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  IconThemeData get iconTheme => Theme.of(this).iconTheme;
  ElevatedButtonThemeData get elevatedButtonTheme => Theme.of(this).elevatedButtonTheme;

  // MediaQuery Extensions
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;

  // Focus Extensions
  void unfocus() {
    final FocusScopeNode currentScope = FocusScope.of(this);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  // Navigation Extensions
  Future push(Widget screen) async =>
      await Navigator.of(this, rootNavigator: true).push(MaterialPageRoute(builder: (_) => screen));
  Future pushReplacement(Widget screen) => Navigator.of(this, rootNavigator: true).pushReplacement(
        MaterialPageRoute(builder: (_) => screen),
      );
  void pop([result]) => Navigator.of(this, rootNavigator: true).pop(result);
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      Navigator.of(this, rootNavigator: true).popUntil(predicate);

  void popToHome() => Navigator.of(this, rootNavigator: true).popUntil((r) => r.isFirst);
}
