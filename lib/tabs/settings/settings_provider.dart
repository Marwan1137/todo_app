// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

/* -------------------------------------------------------------------------- */
/*                            Settings Provider                                 */
/* -------------------------------------------------------------------------- */
class SettingsProvider extends ChangeNotifier {
  /* -------------------------------------------------------------------------- */
  /*                                 Constants                                    */
  /* -------------------------------------------------------------------------- */
  static const String THEME_KEY = "theme";
  static const String LANGUAGE_KEY = "language";

  /* -------------------------------------------------------------------------- */
  /*                              State Variables                                 */
  /* -------------------------------------------------------------------------- */
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';
  bool get isDark => themeMode == ThemeMode.dark;

  String _userId = '';
  String get userId => _userId;

  /* -------------------------------------------------------------------------- */
  /*                                Constructor                                   */
  /* -------------------------------------------------------------------------- */
  SettingsProvider() {
    themeMode = ThemeMode.dark;
    loadSettings();
  }

  /* -------------------------------------------------------------------------- */
  /*                            Settings Management                              */
  /* -------------------------------------------------------------------------- */
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final bool? isDark = prefs.getBool(THEME_KEY);
    if (isDark != null) {
      themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    }

    final String? savedLanguage = prefs.getString(LANGUAGE_KEY);
    if (savedLanguage != null) {
      languageCode = savedLanguage;
    }

    notifyListeners();
  }

  void setUserId(String id) {
    _userId = id;
    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                            Language Management                              */
  /* -------------------------------------------------------------------------- */
  void changeLanguage(String selectedLanguage) async {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(LANGUAGE_KEY, selectedLanguage);

    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                             Theme Management                                */
  /* -------------------------------------------------------------------------- */
  void changeTheme(ThemeMode selectedTheme) async {
    if (themeMode == selectedTheme) return;
    themeMode = selectedTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(THEME_KEY, selectedTheme == ThemeMode.dark);

    notifyListeners();
  }

  /* -------------------------------------------------------------------------- */
  /*                           User Data Management                              */
  /* -------------------------------------------------------------------------- */
  Future<void> initialize() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        _userId = currentUser.uid;
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to initialize settings: $e');
    }
  }
}
