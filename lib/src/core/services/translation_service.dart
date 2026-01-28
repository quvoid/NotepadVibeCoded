import 'package:translator/translator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final translationServiceProvider = Provider((ref) => TranslationService());

class TranslationService {
  final GoogleTranslator _translator = GoogleTranslator();

  Future<String> translateToHindi(String text) async {
    try {
      // ignore: avoid_print
      print('Translating: $text');
      final translation = await _translator.translate(text, to: 'hi');
      // ignore: avoid_print
      print('Translation Result: ${translation.text} (Source: ${translation.sourceLanguage})');
      return translation.text;
    } catch (e) {
      throw Exception('Translation failed: $e');
    }
  }
}
