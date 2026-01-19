// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checklist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChecklistItemImpl _$$ChecklistItemImplFromJson(Map<String, dynamic> json) =>
    _$ChecklistItemImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChecklistItemImplToJson(_$ChecklistItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'isCompleted': instance.isCompleted,
    };
