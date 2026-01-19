import 'package:isar/isar.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String title;

  late String content;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  bool isLocked = false;

  late String colorHex;

  // New feature fields
  @Index()
  bool isPinned = false;

  @Index()
  bool isDeleted = false;

  DateTime? deletedAt;

  // Store tags as JSON string (Isar doesn't support List<String> directly)
  String tagsJson = '[]';

  bool isChecklist = false;

  // Store checklist items as JSON string
  String checklistItemsJson = '[]';

  DateTime? reminderAt;

  String contentType = 'plain'; // 'plain' or 'quill'
}
