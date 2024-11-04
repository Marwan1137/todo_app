import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';
  bool get isDark => themeMode == ThemeMode.dark;

  void changeLanguage(String selectedLanguage) {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;
    notifyListeners();
  }

  void changeTheme(ThemeMode selectedTheme) {
    if (themeMode == selectedTheme) return;
    themeMode = selectedTheme;
    notifyListeners();
  }
}
