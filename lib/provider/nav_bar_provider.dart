import 'package:flutter/material.dart';

class NavbarProvider extends ChangeNotifier {
  int currentTab = 0;

  updateScreen(int tab) {
    currentTab = tab;
    notifyListeners();
  }
}
