import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode;

  ThemeNotifier(this._isDarkMode);

  bool get isDarkMode => _isDarkMode;

  void toggleTheme(bool isDarkMode) {
    _isDarkMode = isDarkMode;
    Hive.box('settings').put('isDarkMode', _isDarkMode);
    notifyListeners();
  }
}