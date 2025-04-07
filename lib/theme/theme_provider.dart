import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _useSystemTheme = false;

  ThemeMode get themeMode => _useSystemTheme ? ThemeMode.system : _themeMode;

  bool get isDarkMode => _useSystemTheme
      ? WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark
      : _themeMode == ThemeMode.dark;

  bool get useSystemTheme => _useSystemTheme;

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _useSystemTheme = false;
    notifyListeners();
  }

  void toggleSystemTheme(bool isEnabled) {
    _useSystemTheme = isEnabled;
    notifyListeners();
  }
}
