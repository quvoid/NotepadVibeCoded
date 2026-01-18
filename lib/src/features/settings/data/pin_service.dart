import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dart_vader_notes/src/core/theme/theme_provider.dart';

const _kAppPinKey = 'app_pin';

class PinService {
  final SharedPreferences _prefs;

  PinService(this._prefs);

  bool get hasPin => _prefs.containsKey(_kAppPinKey);

  Future<void> setPin(String pin) async {
    await _prefs.setString(_kAppPinKey, pin);
  }

  bool verifyPin(String pin) {
    final savedPin = _prefs.getString(_kAppPinKey);
    return savedPin == pin;
  }

  Future<void> removePin() async {
    await _prefs.remove(_kAppPinKey);
  }
}

final pinServiceProvider = Provider<PinService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return PinService(prefs);
});
