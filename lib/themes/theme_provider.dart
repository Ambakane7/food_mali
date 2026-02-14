import 'package:flutter/material.dart';
import 'package:food_mali/themes/dark_mode.dart';
import 'package:food_mali/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == darkMode;

  void toggleTheme() {
    _themeData = isDarkMode ? lightMode : darkMode;
    notifyListeners();
  }

  void setLightMode() {
    _themeData = lightMode;
    notifyListeners();
  }

  void setDarkMode() {
    _themeData = darkMode;
    notifyListeners();
  }
}
