import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/checklist_item.dart';

part 'note.freezed.dart';
part 'note.g.dart';

@freezed
class Note with _$Note {
  const factory Note({
    required String id,
    required String title,
    required String content,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(false) bool isLocked,
    // Hex string for color
    @Default('0xFFFFFFFF') String colorHex,
    // New feature fields
    @Default(false) bool isPinned,
    @Default(false) bool isDeleted,
    DateTime? deletedAt,
    @Default([]) List<String> tags,
    @Default(false) bool isChecklist,
    @Default([]) List<ChecklistItem> checklistItems,
    DateTime? reminderAt,
    @Default('plain') String contentType, // 'plain' or 'quill'
  }) = _Note;

  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);
}
