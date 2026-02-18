// Theme provider - manages light/dark mode
import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode;

  ThemeProvider() : _isDarkMode = StorageService.getIsDarkMode();

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await StorageService.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    if (_isDarkMode == value) return;
    _isDarkMode = value;
    await StorageService.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }
}
