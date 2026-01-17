import 'package:fpdart/fpdart.dart';
import 'package:dart_vader_notes/src/core/errors/failure.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';

abstract interface class NoteRepository {
  /// Stream of all notes, ordered by updated time descending.
  Stream<List<Note>> watchNotes();

  /// Get all notes one-shot.
  Future<Either<Failure, List<Note>>> getNotes();

  /// Get a single note by ID.
  Future<Either<Failure, Note?>> getNote(String id);

  /// Create or Update a note.
  Future<Either<Failure, Unit>> saveNote(Note note);

  /// Delete a note by ID.
  Future<Either<Failure, Unit>> deleteNote(String id);
  
  /// Search notes by query.
  Future<Either<Failure, List<Note>>> searchNotes(String query);
}
