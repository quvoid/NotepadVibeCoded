import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/screens/note_list_screen.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/screens/note_detail_screen.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/screens/splash_screen.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/screens/trash_screen.dart';
import 'package:dart_vader_notes/src/features/settings/presentation/settings_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const NoteListScreen(),
        routes: [
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: 'trash',
            name: 'trash',
            builder: (context, state) => const TrashScreen(),
          ),
          GoRoute(
            path: 'note/:id',
            name: 'note',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return NoteDetailScreen(noteId: id);
            },
          ),
        ],
      ),
    ],
  );
}
