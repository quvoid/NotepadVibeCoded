// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$isarHash() => r'd7adc8890ded9f8bce4df1705bacaa06e9303af0';

/// See also [isar].
@ProviderFor(isar)
final isarProvider = AutoDisposeProvider<Isar>.internal(
  isar,
  name: r'isarProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isarHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsarRef = AutoDisposeProviderRef<Isar>;
String _$noteLocalDataSourceHash() =>
    r'd5a374c7f917774078f77a361d3193101e87b8e8';

/// See also [noteLocalDataSource].
@ProviderFor(noteLocalDataSource)
final noteLocalDataSourceProvider =
    AutoDisposeProvider<NoteLocalDataSource>.internal(
  noteLocalDataSource,
  name: r'noteLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteLocalDataSourceRef = AutoDisposeProviderRef<NoteLocalDataSource>;
String _$noteRepositoryHash() => r'6a2aa75d4b9c9890ed6b369cc45d04606a25a5d9';

/// See also [noteRepository].
@ProviderFor(noteRepository)
final noteRepositoryProvider = AutoDisposeProvider<NoteRepository>.internal(
  noteRepository,
  name: r'noteRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NoteRepositoryRef = AutoDisposeProviderRef<NoteRepository>;
String _$getNotesHash() => r'b6f226dc81a650bc4aff7426dd7379ca8877cad9';

/// See also [getNotes].
@ProviderFor(getNotes)
final getNotesProvider = AutoDisposeProvider<GetNotes>.internal(
  getNotes,
  name: r'getNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetNotesRef = AutoDisposeProviderRef<GetNotes>;
String _$saveNoteHash() => r'c0b9ff759896d42035febc5699f2a2efd823d4b3';

/// See also [saveNote].
@ProviderFor(saveNote)
final saveNoteProvider = AutoDisposeProvider<SaveNote>.internal(
  saveNote,
  name: r'saveNoteProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$saveNoteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SaveNoteRef = AutoDisposeProviderRef<SaveNote>;
String _$deleteNoteHash() => r'0a868a6c729a1cc8e574dd123b4cf68e0fd31620';

/// See also [deleteNote].
@ProviderFor(deleteNote)
final deleteNoteProvider = AutoDisposeProvider<DeleteNote>.internal(
  deleteNote,
  name: r'deleteNoteProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$deleteNoteHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef DeleteNoteRef = AutoDisposeProviderRef<DeleteNote>;
String _$searchNotesHash() => r'556f53cce95149686eb9862ca22678e74e9eddaf';

/// See also [searchNotes].
@ProviderFor(searchNotes)
final searchNotesProvider = AutoDisposeProvider<SearchNotes>.internal(
  searchNotes,
  name: r'searchNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchNotesRef = AutoDisposeProviderRef<SearchNotes>;
String _$notesListHash() => r'0229101dceb6b5ee7ff89362c6f484ced271e1da';

/// See also [notesList].
@ProviderFor(notesList)
final notesListProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  notesList,
  name: r'notesListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$notesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NotesListRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$trashedNotesHash() => r'4f939108541f9556d4103cd647006452ca0f14b5';

/// See also [trashedNotes].
@ProviderFor(trashedNotes)
final trashedNotesProvider = AutoDisposeStreamProvider<List<Note>>.internal(
  trashedNotes,
  name: r'trashedNotesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$trashedNotesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TrashedNotesRef = AutoDisposeStreamProviderRef<List<Note>>;
String _$emptyTrashHash() => r'9ee97802ecacbf530ef7753e8556d5199061bf68';

/// See also [emptyTrash].
@ProviderFor(emptyTrash)
final emptyTrashProvider = AutoDisposeFutureProvider<void>.internal(
  emptyTrash,
  name: r'emptyTrashProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$emptyTrashHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EmptyTrashRef = AutoDisposeFutureProviderRef<void>;
String _$searchQueryHash() => r'3c36752ee11b18a9f1e545eb1a7209a7222d91c9';

/// See also [SearchQuery].
@ProviderFor(SearchQuery)
final searchQueryProvider =
    AutoDisposeNotifierProvider<SearchQuery, String>.internal(
  SearchQuery.new,
  name: r'searchQueryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$searchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SearchQuery = AutoDisposeNotifier<String>;
String _$tagFilterHash() => r'a11be8c402a8f71d4ec13f99274a553d2c06eac6';

/// See also [TagFilter].
@ProviderFor(TagFilter)
final tagFilterProvider =
    AutoDisposeNotifierProvider<TagFilter, String?>.internal(
  TagFilter.new,
  name: r'tagFilterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tagFilterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TagFilter = AutoDisposeNotifier<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
