import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_vader_notes/src/core/data/local_database.dart';
import 'package:dart_vader_notes/src/features/notes/data/datasources/note_local_datasource.dart';
import 'package:dart_vader_notes/src/features/notes/data/repositories/note_repository_impl.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/domain/repositories/note_repository.dart';
import 'package:dart_vader_notes/src/features/notes/domain/usecases/note_usecases.dart';

part 'note_providers.g.dart';

// --- Data Layer Providers ---

@riverpod
Isar isar(IsarRef ref) {
  return LocalDatabase.instance;
}

@riverpod
NoteLocalDataSource noteLocalDataSource(NoteLocalDataSourceRef ref) {
  return NoteLocalDataSourceImpl(ref.watch(isarProvider));
}

@riverpod
NoteRepository noteRepository(NoteRepositoryRef ref) {
  return NoteRepositoryImpl(ref.watch(noteLocalDataSourceProvider));
}

// --- Domain Layer Providers (UseCases) ---

@riverpod
GetNotes getNotes(GetNotesRef ref) {
  return GetNotes(ref.watch(noteRepositoryProvider));
}

@riverpod
SaveNote saveNote(SaveNoteRef ref) {
  return SaveNote(ref.watch(noteRepositoryProvider));
}

@riverpod
DeleteNote deleteNote(DeleteNoteRef ref) {
  return DeleteNote(ref.watch(noteRepositoryProvider));
}

@riverpod
SearchNotes searchNotes(SearchNotesRef ref) {
  return SearchNotes(ref.watch(noteRepositoryProvider));
}

// --- Presentation Layer Providers ---

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void setQuery(String query) => state = query;
}

@riverpod
class TagFilter extends _$TagFilter {
  @override
  String? build() => null;

  void setTag(String? tag) => state = tag;
}

@riverpod
Stream<List<Note>> notesList(NotesListRef ref) {
  final getNotes = ref.watch(getNotesProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final searchNotes = ref.watch(searchNotesProvider);
  final tagFilter = ref.watch(tagFilterProvider);
  
  // If search query is empty, watch all notes
  if (searchQuery.isEmpty) {
    return getNotes.call().map((notes) {
      // Filter out deleted notes
      var filtered = notes.where((note) => !note.isDeleted).toList();
      
      // Filter by tag if selected
      if (tagFilter != null) {
        filtered = filtered.where((note) => note.tags.contains(tagFilter)).toList();
      }
      
      // Sort: pinned notes first, then by updated time
      filtered.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.updatedAt.compareTo(a.updatedAt);
      });
      
      return filtered;
    });
  } 
  
  // If search query is not empty, we need to return a Stream that emits the search results.
  // Converting Future to Stream for search results.
  return Stream.fromFuture(searchNotes.call(searchQuery))
      .map((either) => either.fold(
        (l) => [],
        (r) {
          // Filter out deleted notes and apply tag filter
          var filtered = r.where((note) => !note.isDeleted).toList();
          if (tagFilter != null) {
            filtered = filtered.where((note) => note.tags.contains(tagFilter)).toList();
          }
          return filtered;
        },
      ));
}

@riverpod
Stream<List<Note>> trashedNotes(TrashedNotesRef ref) {
  final getNotes = ref.watch(getNotesProvider);
  
  return getNotes.call().map((notes) {
    return notes.where((note) => note.isDeleted).toList()
      ..sort((a, b) => (b.deletedAt ?? b.updatedAt).compareTo(a.deletedAt ?? a.updatedAt));
  });
}

@riverpod
Future<void> emptyTrash(EmptyTrashRef ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  final result = await repository.getNotes();
  
  await result.fold(
    (failure) async {},
    (notes) async {
      final trashedNotes = notes.where((note) => note.isDeleted);
      for (final note in trashedNotes) {
        await ref.read(deleteNoteProvider).call(note.id);
      }
    },
  );
}
