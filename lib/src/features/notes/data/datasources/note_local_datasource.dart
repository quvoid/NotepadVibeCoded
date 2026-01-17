import 'package:isar/isar.dart';
import 'package:dart_vader_notes/src/features/notes/data/models/note_model.dart';

abstract interface class NoteLocalDataSource {
  Future<List<NoteModel>> getNotes();
  Stream<List<NoteModel>> watchNotes();
  Future<NoteModel?> getNote(String uuid);
  Future<void> saveNote(NoteModel note);
  Future<void> deleteNote(String uuid);
  Future<List<NoteModel>> searchNotes(String query);
}

class NoteLocalDataSourceImpl implements NoteLocalDataSource {
  final Isar isar;

  NoteLocalDataSourceImpl(this.isar);

  @override
  Future<List<NoteModel>> getNotes() async {
    return isar.noteModels.where().sortByUpdatedAtDesc().findAll();
  }

  @override
  Stream<List<NoteModel>> watchNotes() {
    return isar.noteModels.where().sortByUpdatedAtDesc().watch(fireImmediately: true);
  }

  @override
  Future<NoteModel?> getNote(String uuid) async {
    return isar.noteModels.filter().uuidEqualTo(uuid).findFirst();
  }

  @override
  Future<void> saveNote(NoteModel note) async {
    await isar.writeTxn(() async {
      await isar.noteModels.put(note);
    });
  }

  @override
  Future<void> deleteNote(String uuid) async {
    await isar.writeTxn(() async {
      await isar.noteModels.filter().uuidEqualTo(uuid).deleteAll();
    });
  }
  
  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    // Basic search - can be improved with Isar full text search if enabled
    return isar.noteModels
        .filter()
        .titleContains(query, caseSensitive: false)
        .or()
        .contentContains(query, caseSensitive: false)
        .sortByUpdatedAtDesc()
        .findAll();
  }
}
