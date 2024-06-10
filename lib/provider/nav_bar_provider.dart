import 'package:flutter/material.dart';

class NavbarProvider extends ChangeNotifier {
  int currenTab = 0;

  updateScreen(int tab) {
    currenTab = tab;
    notifyListeners();
  }
}
