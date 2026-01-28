import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/quick_note_sheet.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/lightsaber_progress.dart';
import 'package:dart_vader_notes/src/features/settings/data/pin_service.dart';
import 'package:dart_vader_notes/src/core/services/sound_service.dart';
import 'package:dart_vader_notes/src/core/utils/vader_quotes.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/starfield_widget.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/animated_border_container.dart';

class NoteListScreen extends ConsumerWidget {
  const NoteListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);
    final selectedTag = ref.watch(tagFilterProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          // Background Starfield
          const Positioned.fill(
            child: StarfieldWidget(),
          ),
          
          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  AppConstants.spaceBlack.withValues(alpha: 0.8),
                  AppConstants.deepPurple.withValues(alpha: 0.6),
                  Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.9),
                ],
                stops: const [0.0, 0.3, 0.6],
              ),
            ),
            child: CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          AppConstants.lightsaberGlow,
                          AppConstants.sithRed,
                        ],
                      ).createShader(bounds),
                      child: Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          letterSpacing: 1.2,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppConstants.sithRed.withValues(alpha: 0.5),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    centerTitle: false,
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.delete_outline, color: AppConstants.lightsaberGlow),
                      tooltip: 'Trash',
                      onPressed: () => context.push('/trash'),
                    ),
                    IconButton(
                      icon: Icon(Icons.settings, color: AppConstants.lightsaberGlow),
                      onPressed: () => context.push('/settings'),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.p16),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppConstants.lightsaberGlow.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: SearchBar(
                        hintText: 'Search notes...',
                        leading: Icon(Icons.search, color: AppConstants.lightsaberGlow),
                        backgroundColor: WidgetStateProperty.all(Colors.transparent),
                        elevation: WidgetStateProperty.all(0),
                        onChanged: (value) {
                          ref.read(searchQueryProvider.notifier).setQuery(value);
                        },
                      ),
                    ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.p12)),
              
              // Tag filter chips
              notesAsync.when(
                data: (notes) {
                  // Collect all unique tags
                  final allTags = <String>{};
                  for (final note in notes) {
                    allTags.addAll(note.tags);
                  }
                  
                  if (allTags.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
                  
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.p16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              if (selectedTag != null)
                                FilterChip(
                                  label: const Text('All'),
                                  selected: false,
                                  onSelected: (_) => ref.read(tagFilterProvider.notifier).setTag(null),
                                ),
                              ...allTags.map((tag) {
                                return FilterChip(
                                  label: Text(tag),
                                  selected: selectedTag == tag,
                                  onSelected: (selected) {
                                    ref.read(tagFilterProvider.notifier).setTag(selected ? tag : null);
                                  },
                                );
                              }),
                            ],
                          ),
                          const SizedBox(height: AppConstants.p12),
                        ],
                      ),
                    ),
                  );
                },
                error: (_, __) => const SliverToBoxAdapter(child: SizedBox.shrink()),
                loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: AppConstants.p4)),
              notesAsync.when(
                data: (notes) {
                  if (notes.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_add_outlined,
                              size: 120,
                              color: AppConstants.lightsaberGlow.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 24),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  AppConstants.lightsaberGlow,
                                  AppConstants.sithRed.withValues(alpha: 0.7),
                                ],
                              ).createShader(bounds),
                              child: Text(
                                VaderQuotes.getRandomQuote(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Tap the + button to create your first note',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppConstants.lightsaberGlow.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: LightsaberProgress(color: Colors.blue),
                        ),
                        SizedBox(height: 16),
                        Text('Loading...', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)), // Bottom padding for FAB
            ],
          ),
        ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'quick_note',
            backgroundColor: AppConstants.imperialGray,
            foregroundColor: AppConstants.lightsaberGlow,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => const QuickNoteSheet(),
              );
            },
            child: const Icon(Icons.edit),
          ).animate()
            .scale(delay: 100.ms, duration: 300.ms, curve: Curves.elasticOut)
            .fadeIn(),
          const SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'add_note',
            backgroundColor: AppConstants.sithRed,
            foregroundColor: Colors.white,
            onPressed: () => context.push('/note/new'),
            label: const Text('Add Note', style: TextStyle(fontWeight: FontWeight.bold)),
            icon: const Icon(Icons.add),
          ).animate()
            .scale(delay: 200.ms, duration: 300.ms, curve: Curves.elasticOut)
            .fadeIn(),
        ],
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
    final textColor = Colors.white; // Force white text for space theme
    final contentColor = Colors.white70;

    return AnimatedBorderContainer(
      borderWidth: 1.5,
      gradientColors: [
        note.isLocked ? AppConstants.sithRed : AppConstants.lightsaberGlow,
        color.withValues(alpha: 0.1),
        note.isLocked ? AppConstants.sithRed : AppConstants.lightsaberGlow,
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // The Glass Blur
        child: Container(
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15), // Very transparent
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.transparent, // Handled by AnimatedBorderContainer
              width: 0,
            ),
            boxShadow: [
              // Neon Glow
              BoxShadow(
                color: (note.isLocked ? AppConstants.sithRed : AppConstants.lightsaberGlow).withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: InkWell(
            onTap: () => _handleTap(context, ref),
            child: Stack(
              children: [
                 Padding(
                  padding: const EdgeInsets.all(AppConstants.p16),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(
                      sigmaX: note.isLocked ? 6 : 0,
                      sigmaY: note.isLocked ? 6 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pin indicator
                        if (note.isPinned)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Icon(
                              Icons.push_pin,
                              size: 16,
                              color: AppConstants.lightsaberGlow,
                              shadows: [
                                BoxShadow(color: AppConstants.lightsaberGlow, blurRadius: 10, spreadRadius: 2),
                              ],
                            ),
                          ),
                        if (note.title.isNotEmpty) ...[
                          Text(
                            note.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                  shadows: [
                                     Shadow(color: color.withValues(alpha: 0.6), blurRadius: 10),
                                  ],
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppConstants.p8),
                        ],
                        Text(
                          note.isLocked ? 'Encrypted Transmission.\nAuth Required.' : note.content,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: contentColor,
                              ),
                          maxLines: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppConstants.p12),
                        
                        // Tags
                        if (note.tags.isNotEmpty) ...[
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: note.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: textColor.withValues(alpha: 0.8),
                                      ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: AppConstants.p8),
                        ],
                        
                        Row(
                          children: [
                            Text(
                              DateFormat.MMMd().format(note.updatedAt),
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: contentColor.withValues(alpha: 0.5),
                                  ),
                            ),
                            if (note.reminderAt != null) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.alarm,
                                size: 14,
                                color: AppConstants.sithRed.withValues(alpha: 0.8),
                              ),
                            ],
                            if (note.isChecklist) ...[
                              const SizedBox(width: 8),
                              Icon(
                                Icons.checklist,
                                size: 14,
                                color: AppConstants.lightsaberGlow.withValues(alpha: 0.8),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (note.isLocked)
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppConstants.sithRed, width: 2),
                          boxShadow: [
                             BoxShadow(color: AppConstants.sithRed.withValues(alpha: 0.5), blurRadius: 20),
                          ],
                        ),
                        child: Icon(Icons.lock, color: AppConstants.sithRed, size: 32),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
    ).animate()
      .fadeIn(duration: 400.ms, curve: Curves.easeOut)
      .slideY(begin: 0.2, end: 0, duration: 400.ms, curve: Curves.easeOut)
      .shimmer(delay: 500.ms, duration: 1000.ms, color: Colors.white10);
  }
}
