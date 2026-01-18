import 'package:dart_vader_notes/src/features/notes/data/models/note_model.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';

extension NoteModelToEntity on NoteModel {
  Note toEntity() {
    return Note(
      id: uuid,
      title: title,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isLocked: isLocked,
      colorHex: colorHex,
    );
  }
}

extension NoteEntityToModel on Note {
  NoteModel toModel() {
    return NoteModel()
      ..uuid = id
      ..title = title
      ..content = content
      ..createdAt = createdAt
      ..updatedAt = updatedAt
      ..isLocked = isLocked
      ..colorHex = colorHex;
  }
}
