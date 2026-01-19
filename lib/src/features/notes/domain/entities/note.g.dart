// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NoteImpl _$$NoteImplFromJson(Map<String, dynamic> json) => _$NoteImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isLocked: json['isLocked'] as bool? ?? false,
      colorHex: json['colorHex'] as String? ?? '0xFFFFFFFF',
      isPinned: json['isPinned'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      isChecklist: json['isChecklist'] as bool? ?? false,
      checklistItems: (json['checklistItems'] as List<dynamic>?)
              ?.map((e) => ChecklistItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reminderAt: json['reminderAt'] == null
          ? null
          : DateTime.parse(json['reminderAt'] as String),
      contentType: json['contentType'] as String? ?? 'plain',
    );

Map<String, dynamic> _$$NoteImplToJson(_$NoteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isLocked': instance.isLocked,
      'colorHex': instance.colorHex,
      'isPinned': instance.isPinned,
      'isDeleted': instance.isDeleted,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'tags': instance.tags,
      'isChecklist': instance.isChecklist,
      'checklistItems': instance.checklistItems,
      'reminderAt': instance.reminderAt?.toIso8601String(),
      'contentType': instance.contentType,
    };
