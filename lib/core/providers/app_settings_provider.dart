import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _localeKey = 'locale';
  static const String _isFirstRunKey = 'is_first_run';

  final SharedPreferences _prefs;

  ThemeMode _themeMode;
  Locale _locale;
  bool _isFirstRun;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isArabic => _locale.languageCode == 'ar';
  bool get isFirstRun => _isFirstRun;

  /// Accept pre-warmed SharedPreferences — no async needed at startup.
  AppSettingsProvider({required SharedPreferences prefs})
      : _prefs = prefs,
        _themeMode = (prefs.getInt(_themeModeKey) ?? 0) == 1
            ? ThemeMode.dark
            : ThemeMode.light,
        _locale = Locale(prefs.getString(_localeKey) ?? 'en'),
        _isFirstRun = prefs.getBool(_isFirstRunKey) ?? true;

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await _prefs.setInt(_themeModeKey, _themeMode == ThemeMode.dark ? 1 : 0);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString(_localeKey, locale.languageCode);
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
    await _prefs.setBool(_isFirstRunKey, false);
    notifyListeners();
  }
}
