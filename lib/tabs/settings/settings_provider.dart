// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* -------------------------------------------------------------------------- */
/*                            Settings Provider Class                           */
/* -------------------------------------------------------------------------- */
class SettingsProvider extends ChangeNotifier {
  // Keys for SharedPreferences
  static const String THEME_KEY = "theme";
  static const String LANGUAGE_KEY = "language";

  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';
  bool get isDark => themeMode == ThemeMode.dark;

  // Initialize settings from SharedPreferences
  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme
    final bool? isDark = prefs.getBool(THEME_KEY);
    if (isDark != null) {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    // Load language
    final String? savedLanguage = prefs.getString(LANGUAGE_KEY);
    if (savedLanguage != null) {
      languageCode = savedLanguage;
    }

    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                            Language Change Handler                           */
  /* -------------------------------------------------------------------------- */
  void changeLanguage(String selectedLanguage) async {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_KEY, selectedLanguage);

    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                            Theme Change Handler                              */
  /* -------------------------------------------------------------------------- */
  void changeTheme(ThemeMode selectedTheme) async {
    if (themeMode == selectedTheme) return;
    themeMode = selectedTheme;

    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, selectedTheme == ThemeMode.dark);

    notifyListeners();
  }
}
