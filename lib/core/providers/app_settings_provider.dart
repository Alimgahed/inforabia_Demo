import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _isFirstRunKey = 'is_first_run';

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('en');
  bool _isFirstRun = true;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isFirstRun => _isFirstRun;

  AppSettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeModeKey) ?? 0;
    final langCode = prefs.getString(_localeKey) ?? 'en';

    _themeMode = themeIndex == 1 ? ThemeMode.dark : ThemeMode.light;
    _locale = Locale(langCode);
    _isFirstRun = prefs.getBool(_isFirstRunKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, _themeMode == ThemeMode.dark ? 1 : 0);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    final newLocale = _locale.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    await setLocale(newLocale);
  }

  Future<void> completeSetup() async {
    _isFirstRun = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstRunKey, false);
    notifyListeners();
  }
}
