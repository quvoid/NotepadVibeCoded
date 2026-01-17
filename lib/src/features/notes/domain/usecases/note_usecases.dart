import 'package:fpdart/fpdart.dart';
import 'package:dart_vader_notes/src/core/errors/failure.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/domain/repositories/note_repository.dart';

class GetNotes {
  final NoteRepository repository;
  GetNotes(this.repository);

  Stream<List<Note>> call() {
    return repository.watchNotes();
  }
}

class SaveNote {
  final NoteRepository repository;
  SaveNote(this.repository);

  Future<Either<Failure, Unit>> call(Note note) {
    return repository.saveNote(note);
  }
}

class DeleteNote {
  final NoteRepository repository;
  DeleteNote(this.repository);

  Future<Either<Failure, Unit>> call(String id) {
    return repository.deleteNote(id);
  }
}

class SearchNotes {
  final NoteRepository repository;
  SearchNotes(this.repository);

  Future<Either<Failure, List<Note>>> call(String query) {
    return repository.searchNotes(query);
  }
}
