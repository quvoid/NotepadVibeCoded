import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dart_vader_notes/src/core/router/app_router.dart';
import 'package:dart_vader_notes/src/core/theme/app_theme.dart';
import 'package:dart_vader_notes/src/core/theme/theme_provider.dart';

class DartVaderApp extends ConsumerWidget {
  const DartVaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'Dart Vader Notes',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
