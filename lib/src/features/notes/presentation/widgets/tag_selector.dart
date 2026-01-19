import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  final List<String> selectedTags;
  final Function(List<String>) onTagsChanged;

  const TagSelector({
    super.key,
    required this.selectedTags,
    required this.onTagsChanged,
  });

  @override
  State<TagSelector> createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  final TextEditingController _tagController = TextEditingController();
  
  // Predefined tag suggestions
  static const List<String> _suggestions = [
    'Work',
    'Personal',
    'Ideas',
    'Important',
    'Todo',
    'Study',
    'Project',
    'Meeting',
  ];

  void _addTag(String tag) {
    if (tag.isEmpty || widget.selectedTags.contains(tag)) return;
    
    final newTags = [...widget.selectedTags, tag];
    widget.onTagsChanged(newTags);
    _tagController.clear();
  }

  void _removeTag(String tag) {
    final newTags = widget.selectedTags.where((t) => t != tag).toList();
    widget.onTagsChanged(newTags);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Selected tags
        if (widget.selectedTags.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () => _removeTag(tag),
                deleteIcon: const Icon(Icons.close, size: 18),
              );
            }).toList(),
          ),
        const SizedBox(height: 12),
        
        // Add tag input
        TextField(
          controller: _tagController,
          decoration: InputDecoration(
            labelText: 'Add tag',
            hintText: 'Type a tag name',
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _addTag(_tagController.text.trim()),
            ),
          ),
          onSubmitted: (value) => _addTag(value.trim()),
        ),
        const SizedBox(height: 12),
        
        // Tag suggestions
        Text(
          'Suggestions:',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _suggestions
              .where((tag) => !widget.selectedTags.contains(tag))
              .map((tag) {
            return ActionChip(
              label: Text(tag),
              onPressed: () => _addTag(tag),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }
}
