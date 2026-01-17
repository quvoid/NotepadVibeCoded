import 'package:fpdart/fpdart.dart';
import 'package:dart_vader_notes/src/core/errors/failure.dart';
import 'package:dart_vader_notes/src/features/notes/data/datasources/note_local_datasource.dart';
import 'package:dart_vader_notes/src/features/notes/data/models/note_mapper.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteLocalDataSource localDataSource;

  NoteRepositoryImpl(this.localDataSource);

  @override
  Stream<List<Note>> watchNotes() {
    return localDataSource.watchNotes().map((models) {
      return models.map((e) => e.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return right(unit);
    } catch (e, st) {
      return left(DatabaseFailure(message: e.toString(), error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Note?>> getNote(String id) async {
    try {
      final model = await localDataSource.getNote(id);
      return right(model?.toEntity());
    } catch (e, st) {
      return left(DatabaseFailure(message: e.toString(), error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    try {
      final models = await localDataSource.getNotes();
      return right(models.map((e) => e.toEntity()).toList());
    } catch (e, st) {
      return left(DatabaseFailure(message: e.toString(), error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveNote(Note note) async {
    try {
      await localDataSource.saveNote(note.toModel());
      return right(unit);
    } catch (e, st) {
      return left(DatabaseFailure(message: e.toString(), error: e, stackTrace: st));
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final models = await localDataSource.searchNotes(query);
      return right(models.map((e) => e.toEntity()).toList());
    } catch (e, st) {
      return left(DatabaseFailure(message: e.toString(), error: e, stackTrace: st));
    }
  }
}
