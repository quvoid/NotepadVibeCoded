import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';

class QuickNoteSheet extends ConsumerStatefulWidget {
  const QuickNoteSheet({super.key});

  @override
  ConsumerState<QuickNoteSheet> createState() => _QuickNoteSheetState();
}

class _QuickNoteSheetState extends ConsumerState<QuickNoteSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Quick Note',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Type your note...',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _saveQuickNote(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _saveQuickNote,
                icon: const Icon(Icons.check),
                label: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _saveQuickNote() async {
    if (_controller.text.trim().isEmpty) {
      Navigator.pop(context);
      return;
    }

    final note = Note(
      id: const Uuid().v4(),
      title: '',
      content: _controller.text.trim(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(saveNoteProvider).call(note);

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quick note saved')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
