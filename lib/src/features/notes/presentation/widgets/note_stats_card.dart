import 'package:flutter/material.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:intl/intl.dart';

class NoteStatsCard extends StatelessWidget {
  final Note note;

  const NoteStatsCard({super.key, required this.note});

  int _countWords(String text) {
    if (text.isEmpty) return 0;
    return text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  int _estimateReadingTime(int wordCount) {
    // Average reading speed: 200 words per minute
    return (wordCount / 200).ceil();
  }

  @override
  Widget build(BuildContext context) {
    final fullText = '${note.title} ${note.content}';
    final wordCount = _countWords(fullText);
    final charCount = fullText.length;
    final readingTime = _estimateReadingTime(wordCount);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _StatRow(
              icon: Icons.text_fields,
              label: 'Words',
              value: wordCount.toString(),
            ),
            const SizedBox(height: 8),
            _StatRow(
              icon: Icons.format_size,
              label: 'Characters',
              value: charCount.toString(),
            ),
            const SizedBox(height: 8),
            _StatRow(
              icon: Icons.access_time,
              label: 'Reading time',
              value: '$readingTime min',
            ),
            const Divider(height: 24),
            _StatRow(
              icon: Icons.calendar_today,
              label: 'Created',
              value: DateFormat('MMM dd, yyyy').format(note.createdAt),
            ),
            const SizedBox(height: 8),
            _StatRow(
              icon: Icons.update,
              label: 'Updated',
              value: DateFormat('MMM dd, yyyy').format(note.updatedAt),
            ),
            if (note.isChecklist) ...[
              const Divider(height: 24),
              _StatRow(
                icon: Icons.checklist,
                label: 'Checklist progress',
                value: '${note.checklistItems.where((i) => i.isCompleted).length}/${note.checklistItems.length}',
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
