import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';
import 'package:intl/intl.dart';

class TrashScreen extends ConsumerWidget {
  const TrashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trashedNotesAsync = ref.watch(trashedNotesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trash'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Empty Trash'),
                  content: const Text('Permanently delete all notes in trash? This cannot be undone.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        await ref.read(emptyTrashProvider.future);
                        if (context.mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Trash emptied')),
                          );
                        }
                      },
                      child: const Text('Delete All'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: trashedNotesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Trash is empty', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes[index];
              return _TrashNoteCard(note: note);
            },
          );
        },
        error: (error, st) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _TrashNoteCard extends ConsumerWidget {
  final Note note;

  const _TrashNoteCard({required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysInTrash = note.deletedAt != null
        ? DateTime.now().difference(note.deletedAt!).inDays
        : 0;
    final daysRemaining = 30 - daysInTrash;

    return Card(
      child: ListTile(
        title: Text(
          note.title.isEmpty ? 'Untitled' : note.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              'Deleted ${DateFormat.MMMd().format(note.deletedAt!)} • Deletes in $daysRemaining days',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.orange,
                  ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.restore),
              tooltip: 'Restore',
              onPressed: () async {
                final restoredNote = note.copyWith(
                  isDeleted: false,
                  deletedAt: null,
                );
                await ref.read(saveNoteProvider).call(restoredNote);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Note restored')),
                  );
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Delete permanently',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Permanently'),
                    content: const Text('This note will be permanently deleted. This cannot be undone.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          await ref.read(deleteNoteProvider).call(note.id);
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Note permanently deleted')),
                            );
                          }
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
