import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Manages locale/language selection and persistence
class LocaleManager extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  Locale _locale = const Locale('en');

  LocaleManager() {
    _loadLocale();
  }

  Locale get locale => _locale;

  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    
    if (languageCode != null) {
      _locale = Locale(languageCode);
      notifyListeners();
    }
  }

  /// Change the app locale and persist the choice
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  /// Get list of supported locales
  static List<Locale> get supportedLocales => const [
    Locale('en'), // English
    Locale('zh'), // Chinese (Simplified)
  ];

  /// Check if a locale is supported
  static bool isSupported(Locale locale) {
    return supportedLocales.any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  /// Get display name for a locale
  static String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'zh':
        return '简体中文';
      default:
        return locale.languageCode;
    }
  }
}
