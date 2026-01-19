import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/checklist_item.dart';

class ChecklistEditor extends StatefulWidget {
  final List<ChecklistItem> items;
  final Function(List<ChecklistItem>) onItemsChanged;

  const ChecklistEditor({
    super.key,
    required this.items,
    required this.onItemsChanged,
  });

  @override
  State<ChecklistEditor> createState() => _ChecklistEditorState();
}

class _ChecklistEditorState extends State<ChecklistEditor> {
  final TextEditingController _newItemController = TextEditingController();

  void _addItem() {
    if (_newItemController.text.trim().isEmpty) return;

    final newItem = ChecklistItem(
      id: const Uuid().v4(),
      text: _newItemController.text.trim(),
      isCompleted: false,
    );

    widget.onItemsChanged([...widget.items, newItem]);
    _newItemController.clear();
  }

  void _toggleItem(ChecklistItem item) {
    final updatedItems = widget.items.map((i) {
      if (i.id == item.id) {
        return item.copyWith(isCompleted: !item.isCompleted);
      }
      return i;
    }).toList();

    widget.onItemsChanged(updatedItems);
  }

  void _deleteItem(ChecklistItem item) {
    final updatedItems = widget.items.where((i) => i.id != item.id).toList();
    widget.onItemsChanged(updatedItems);
  }

  void _editItem(ChecklistItem item, String newText) {
    if (newText.trim().isEmpty) {
      _deleteItem(item);
      return;
    }

    final updatedItems = widget.items.map((i) {
      if (i.id == item.id) {
        return item.copyWith(text: newText.trim());
      }
      return i;
    }).toList();

    widget.onItemsChanged(updatedItems);
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = widget.items.where((i) => i.isCompleted).length;
    final totalCount = widget.items.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator
        if (totalCount > 0) ...[
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: totalCount > 0 ? completedCount / totalCount : 0,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '$completedCount/$totalCount',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Checklist items
        ...widget.items.map((item) {
          return _ChecklistItemTile(
            item: item,
            onToggle: () => _toggleItem(item),
            onDelete: () => _deleteItem(item),
            onEdit: (newText) => _editItem(item, newText),
          );
        }),

        const SizedBox(height: 12),

        // Add new item
        TextField(
          controller: _newItemController,
          decoration: InputDecoration(
            hintText: 'Add checklist item',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.add_circle_outline),
            suffixIcon: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addItem,
            ),
          ),
          onSubmitted: (_) => _addItem(),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }
}

class _ChecklistItemTile extends StatefulWidget {
  final ChecklistItem item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Function(String) onEdit;

  const _ChecklistItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<_ChecklistItemTile> createState() => _ChecklistItemTileState();
}

class _ChecklistItemTileState extends State<_ChecklistItemTile> {
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: widget.item.text);
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _editController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onSubmitted: (value) {
                    widget.onEdit(value);
                    setState(() => _isEditing = false);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () {
                  widget.onEdit(_editController.text);
                  setState(() => _isEditing = false);
                },
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: ListTile(
        leading: Checkbox(
          value: widget.item.isCompleted,
          onChanged: (_) => widget.onToggle(),
        ),
        title: Text(
          widget.item.text,
          style: TextStyle(
            decoration: widget.item.isCompleted ? TextDecoration.lineThrough : null,
            color: widget.item.isCompleted ? Colors.grey : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => setState(() => _isEditing = true),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: widget.onDelete,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }
}
