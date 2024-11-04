import 'package:flutter/material.dart';

/* -------------------------------------------------------------------------- */
/*                            Settings Provider Class                           */
/* -------------------------------------------------------------------------- */
class SettingsProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';
  bool get isDark => themeMode == ThemeMode.dark;

  /* -------------------------------------------------------------------------- */
  /*                            Language Change Handler                           */
  /* -------------------------------------------------------------------------- */
  void changeLanguage(String selectedLanguage) {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                            Theme Change Handler                              */
  /* -------------------------------------------------------------------------- */
  void changeTheme(ThemeMode selectedTheme) {
    if (themeMode == selectedTheme) return;
    themeMode = selectedTheme;
    notifyListeners();
  }
}
