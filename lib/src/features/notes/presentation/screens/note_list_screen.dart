import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';
import 'package:dart_vader_notes/src/features/settings/data/pin_service.dart';
import 'package:intl/intl.dart';

class NoteListScreen extends ConsumerWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            title: const Text(AppConstants.appName),
            centerTitle: false,
            actions: [
               IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                   context.push('/settings');
                },
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.p16),
            sliver: SliverToBoxAdapter(
              child: SearchBar(
                hintText: 'Search notes...',
                leading: const Icon(Icons.search),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).setQuery(value);
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: AppConstants.p16)),
          notesAsync.when(
            data: (notes) {
              if (notes.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Text('No notes found. Create one!'),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.p16),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppConstants.p12,
                  crossAxisSpacing: AppConstants.p12,
                  childCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteCard(note: note);
                  },
                ),
              );
            },
            error: (error, st) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom padding for FAB
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/note/new'),
        label: const Text('Add Note'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  void _handleTap(BuildContext context, WidgetRef ref) {
    if (!note.isLocked) {
      context.push('/note/${note.id}');
      return;
    }

    // Locked Logic
    showDialog(
      context: context,
      builder: (context) {
        final pinController = TextEditingController();
        return AlertDialog(
          title: const Text('Private Note'),
          content: TextField(
            controller: pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            autofocus: true, 
            decoration: const InputDecoration(labelText: 'Enter PIN'),
            onSubmitted: (val) {
               _verifyPin(context, ref, val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
             TextButton(
              onPressed: () => _verifyPin(context, ref, pinController.text),
              child: const Text('Unlock'),
            ),
          ],
        );
      },
    );
  }

  void _verifyPin(BuildContext context, WidgetRef ref, String enteredPin) {
     final pinService = ref.read(pinServiceProvider);
     if (pinService.verifyPin(enteredPin)) {
        Navigator.pop(context); // Close dialog
        context.push('/note/${note.id}');
     } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect PIN'), duration: Duration(seconds: 1)),
        );
     }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(note.colorHex));
    final isDark = color.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;
    final contentColor = isDark ? Colors.white70 : Colors.black54;

    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        child: Stack(
          children: [
             Padding(
              padding: const EdgeInsets.all(AppConstants.p16),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: note.isLocked ? 5 : 0,
                  sigmaY: note.isLocked ? 5 : 0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (note.title.isNotEmpty) ...[
                      Text(
                        note.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.p8),
                    ],
                    Text(
                      note.isLocked ? 'This note is private.\nUnlocked with PIN.' : note.content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: contentColor,
                          ),
                      maxLines: 8,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppConstants.p12),
                    Text(
                      DateFormat.MMMd().format(note.updatedAt),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: contentColor.withValues(alpha: 0.6),
                          ),
                    ),
                  ],
                ),
              ),
            ),
            if (note.isLocked)
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(Icons.lock, color: Colors.white, size: 32),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
