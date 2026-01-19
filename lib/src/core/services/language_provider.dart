import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_vader_notes/src/core/theme/theme_provider.dart';

// Keys
const _kLanguageKey = 'tts_language';

// Supported languages
const String kLanguageHindi = 'hi-IN';
const String kLanguageEnglish = 'en-US';

class LanguageNotifier extends StateNotifier<String> {
  final SharedPreferences _prefs;

  LanguageNotifier(this._prefs) : super(_loadLanguage(_prefs));

  static String _loadLanguage(SharedPreferences prefs) {
    final savedLanguage = prefs.getString(_kLanguageKey);
    if (savedLanguage == kLanguageHindi) return kLanguageHindi;
    if (savedLanguage == kLanguageEnglish) return kLanguageEnglish;
    return kLanguageEnglish; // Default to English
  }

  Future<void> setLanguage(String languageCode) async {
    state = languageCode;
    await _prefs.setString(_kLanguageKey, languageCode);
  }

  String get languageName {
    switch (state) {
      case kLanguageHindi:
        return 'Hindi';
      case kLanguageEnglish:
        return 'English';
      default:
        return 'English';
    }
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LanguageNotifier(prefs);
});
