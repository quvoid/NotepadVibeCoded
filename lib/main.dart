import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_vader_notes/src/app.dart';
import 'package:dart_vader_notes/src/core/data/local_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database
  await LocalDatabase.init();

  runApp(
    const ProviderScope(
      child: DartVaderApp(),
    ),
  );
}
