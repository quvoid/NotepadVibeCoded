import 'dart:convert';
import 'package:dart_vader_notes/src/features/notes/data/models/note_model.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/checklist_item.dart';

extension NoteModelToEntity on NoteModel {
  Note toEntity() {
    // Parse checklist items from JSON
    List<ChecklistItem> items = [];
    try {
      final jsonList = jsonDecode(checklistItemsJson) as List;
      items = jsonList.map((item) => ChecklistItem.fromJson(item as Map<String, dynamic>)).toList();
    } catch (_) {
      items = [];
    }

    // Parse tags from JSON
    List<String> tagsList = [];
    try {
      final jsonList = jsonDecode(tagsJson) as List;
      tagsList = jsonList.map((tag) => tag.toString()).toList();
    } catch (_) {
      tagsList = [];
    }

    return Note(
      id: uuid,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isLocked: isLocked,
      colorHex: colorHex,
      isPinned: isPinned,
      isDeleted: isDeleted,
      deletedAt: deletedAt,
      tags: tagsList,
      isChecklist: isChecklist,
      checklistItems: items,
      reminderAt: reminderAt,
      contentType: contentType,
    );
  }
}

extension NoteEntityToModel on Note {
  NoteModel toModel() {
    // Convert checklist items to JSON
    final itemsJson = jsonEncode(checklistItems.map((item) => item.toJson()).toList());
    
    // Convert tags to JSON
    final tagsJsonStr = jsonEncode(tags);

    return NoteModel()
      ..uuid = id
      ..title = title
      ..content = content
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..isLocked = isLocked
      ..colorHex = colorHex
      ..isPinned = isPinned
      ..isDeleted = isDeleted
      ..deletedAt = deletedAt
      ..tagsJson = tagsJsonStr
      ..isChecklist = isChecklist
      ..checklistItemsJson = itemsJson
      ..reminderAt = reminderAt
      ..contentType = contentType;
  }
}
