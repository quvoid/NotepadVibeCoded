import 'package:dart_vader_notes/src/app.dart';
import 'package:dart_vader_notes/src/core/data/local_database.dart';
import 'package:dart_vader_notes/src/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database
  await LocalDatabase.init();
  
  // Initialize Preferences
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DartVaderApp(),
    ),
  );
}
