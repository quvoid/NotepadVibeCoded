// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Note _$NoteFromJson(Map<String, dynamic> json) {
  return _Note.fromJson(json);
}

/// @nodoc
mixin _$Note {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isLocked =>
      throw _privateConstructorUsedError; // Hex string for color
  String get colorHex =>
      throw _privateConstructorUsedError; // New feature fields
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isDeleted => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isChecklist => throw _privateConstructorUsedError;
  List<ChecklistItem> get checklistItems => throw _privateConstructorUsedError;
  DateTime? get reminderAt => throw _privateConstructorUsedError;
  String get contentType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteCopyWith<Note> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteCopyWith<$Res> {
  factory $NoteCopyWith(Note value, $Res Function(Note) then) =
      _$NoteCopyWithImpl<$Res, Note>;
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime createdAt,
      DateTime updatedAt,
      bool isLocked,
      String colorHex,
      bool isPinned,
      bool isDeleted,
      DateTime? deletedAt,
      List<String> tags,
      bool isChecklist,
      List<ChecklistItem> checklistItems,
      DateTime? reminderAt,
      String contentType});
}

/// @nodoc
class _$NoteCopyWithImpl<$Res, $Val extends Note>
    implements $NoteCopyWith<$Res> {
  _$NoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLocked = null,
    Object? colorHex = null,
    Object? isPinned = null,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? tags = null,
    Object? isChecklist = null,
    Object? checklistItems = null,
    Object? reminderAt = freezed,
    Object? contentType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isChecklist: null == isChecklist
          ? _value.isChecklist
          : isChecklist // ignore: cast_nullable_to_non_nullable
              as bool,
      checklistItems: null == checklistItems
          ? _value.checklistItems
          : checklistItems // ignore: cast_nullable_to_non_nullable
              as List<ChecklistItem>,
      reminderAt: freezed == reminderAt
          ? _value.reminderAt
          : reminderAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NoteImplCopyWith<$Res> implements $NoteCopyWith<$Res> {
  factory _$$NoteImplCopyWith(
          _$NoteImpl value, $Res Function(_$NoteImpl) then) =
      __$$NoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String content,
      DateTime createdAt,
      DateTime updatedAt,
      bool isLocked,
      String colorHex,
      bool isPinned,
      bool isDeleted,
      DateTime? deletedAt,
      List<String> tags,
      bool isChecklist,
      List<ChecklistItem> checklistItems,
      DateTime? reminderAt,
      String contentType});
}

/// @nodoc
class __$$NoteImplCopyWithImpl<$Res>
    extends _$NoteCopyWithImpl<$Res, _$NoteImpl>
    implements _$$NoteImplCopyWith<$Res> {
  __$$NoteImplCopyWithImpl(_$NoteImpl _value, $Res Function(_$NoteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isLocked = null,
    Object? colorHex = null,
    Object? isPinned = null,
    Object? isDeleted = null,
    Object? deletedAt = freezed,
    Object? tags = null,
    Object? isChecklist = null,
    Object? checklistItems = null,
    Object? reminderAt = freezed,
    Object? contentType = null,
  }) {
    return _then(_$NoteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isLocked: null == isLocked
          ? _value.isLocked
          : isLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      colorHex: null == colorHex
          ? _value.colorHex
          : colorHex // ignore: cast_nullable_to_non_nullable
              as String,
      isPinned: null == isPinned
          ? _value.isPinned
          : isPinned // ignore: cast_nullable_to_non_nullable
              as bool,
      isDeleted: null == isDeleted
          ? _value.isDeleted
          : isDeleted // ignore: cast_nullable_to_non_nullable
              as bool,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isChecklist: null == isChecklist
          ? _value.isChecklist
          : isChecklist // ignore: cast_nullable_to_non_nullable
              as bool,
      checklistItems: null == checklistItems
          ? _value._checklistItems
          : checklistItems // ignore: cast_nullable_to_non_nullable
              as List<ChecklistItem>,
      reminderAt: freezed == reminderAt
          ? _value.reminderAt
          : reminderAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoteImpl implements _Note {
  const _$NoteImpl(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.updatedAt,
      this.isLocked = false,
      this.colorHex = '0xFFFFFFFF',
      this.isPinned = false,
      this.isDeleted = false,
      this.deletedAt,
      final List<String> tags = const [],
      this.isChecklist = false,
      final List<ChecklistItem> checklistItems = const [],
      this.reminderAt,
      this.contentType = 'plain'})
      : _tags = tags,
        _checklistItems = checklistItems;

  factory _$NoteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String content;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isLocked;
// Hex string for color
  @override
  @JsonKey()
  final String colorHex;
// New feature fields
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isDeleted;
  @override
  final DateTime? deletedAt;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @JsonKey()
  final bool isChecklist;
  final List<ChecklistItem> _checklistItems;
  @override
  @JsonKey()
  List<ChecklistItem> get checklistItems {
    if (_checklistItems is EqualUnmodifiableListView) return _checklistItems;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_checklistItems);
  }

  @override
  final DateTime? reminderAt;
  @override
  @JsonKey()
  final String contentType;

  @override
  String toString() {
    return 'Note(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt, isLocked: $isLocked, colorHex: $colorHex, isPinned: $isPinned, isDeleted: $isDeleted, deletedAt: $deletedAt, tags: $tags, isChecklist: $isChecklist, checklistItems: $checklistItems, reminderAt: $reminderAt, contentType: $contentType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isLocked, isLocked) ||
                other.isLocked == isLocked) &&
            (identical(other.colorHex, colorHex) ||
                other.colorHex == colorHex) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isChecklist, isChecklist) ||
                other.isChecklist == isChecklist) &&
            const DeepCollectionEquality()
                .equals(other._checklistItems, _checklistItems) &&
            (identical(other.reminderAt, reminderAt) ||
                other.reminderAt == reminderAt) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      content,
      createdAt,
      updatedAt,
      isLocked,
      colorHex,
      isPinned,
      isDeleted,
      deletedAt,
      const DeepCollectionEquality().hash(_tags),
      isChecklist,
      const DeepCollectionEquality().hash(_checklistItems),
      reminderAt,
      contentType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      __$$NoteImplCopyWithImpl<_$NoteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteImplToJson(
      this,
    );
  }
}

abstract class _Note implements Note {
  const factory _Note(
      {required final String id,
      required final String title,
      required final String content,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isLocked,
      final String colorHex,
      final bool isPinned,
      final bool isDeleted,
      final DateTime? deletedAt,
      final List<String> tags,
      final bool isChecklist,
      final List<ChecklistItem> checklistItems,
      final DateTime? reminderAt,
      final String contentType}) = _$NoteImpl;

  factory _Note.fromJson(Map<String, dynamic> json) = _$NoteImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get content;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isLocked;
  @override // Hex string for color
  String get colorHex;
  @override // New feature fields
  bool get isPinned;
  @override
  bool get isDeleted;
  @override
  DateTime? get deletedAt;
  @override
  List<String> get tags;
  @override
  bool get isChecklist;
  @override
  List<ChecklistItem> get checklistItems;
  @override
  DateTime? get reminderAt;
  @override
  String get contentType;
  @override
  @JsonKey(ignore: true)
  _$$NoteImplCopyWith<_$NoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
