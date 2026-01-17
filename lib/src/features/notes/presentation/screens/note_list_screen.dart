import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';
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
                   // Navigate to settings
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

class NoteCard extends StatelessWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final color = Color(int.parse(note.colorHex));
    // Determine if color is dark to adjust text color
    final isDark = color.computeLuminance() < 0.5;
    final textColor = isDark ? Colors.white : Colors.black87;
    final contentColor = isDark ? Colors.white70 : Colors.black54;

    return Card(
      color: color,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/note/${note.id}'),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.p16),
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
                note.content,
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
                      color: contentColor.withOpacity(0.6),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
