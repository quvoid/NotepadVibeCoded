import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_vader_notes/src/core/services/language_provider.dart';

part 'tts_service.g.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isPaused = false;

  TtsService({String initialLanguage = 'en-US'}) {
    _initTts(initialLanguage);
  }

  Future<void> _initTts(String language) async {
    await _flutterTts.setLanguage(language);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
      _isPaused = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isSpeaking = false;
      _isPaused = false;
    });
  }

  Future<void> setLanguage(String languageCode) async {
    await _flutterTts.setLanguage(languageCode);
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    // Check if text contains Devanagari characters (Hindi)
    final hasHindi = RegExp(r'[\u0900-\u097F]').hasMatch(text);
    if (hasHindi) {
      await _flutterTts.setLanguage('hi-IN');
    } else {
      // Default to English (or whatever was set initially)
      // Ideally we should track the 'default' language
      await _flutterTts.setLanguage('en-US');
    }
    
    if (_isPaused) {
      // Resume if paused
      _isPaused = false;
      _isSpeaking = true;
      // Note: FlutterTts doesn't have native resume, so we restart
      await _flutterTts.speak(text);
    } else {
      _isSpeaking = true;
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
    _isPaused = false;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _isPaused = true;
    _isSpeaking = false;
  }

  Future<void> setRate(double rate) async {
    await _flutterTts.setSpeechRate(rate);
  }

  bool get isSpeaking => _isSpeaking;
  bool get isPaused => _isPaused;

  void dispose() {
    _flutterTts.stop();
  }
}

@riverpod
TtsService ttsService(TtsServiceRef ref) {
  final language = ref.watch(languageProvider);
  final service = TtsService(initialLanguage: language);
  
  // Listen to language changes
  ref.listen(languageProvider, (previous, next) {
    service.setLanguage(next);
  });
  
  ref.onDispose(() => service.dispose());
  return service;
}

