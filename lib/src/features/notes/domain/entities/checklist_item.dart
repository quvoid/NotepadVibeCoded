import 'package:freezed_annotation/freezed_annotation.dart';

part 'checklist_item.freezed.dart';
part 'checklist_item.g.dart';

@freezed
class ChecklistItem with _$ChecklistItem {
  const factory ChecklistItem({
    required String id,
    required String text,
    @Default(false) bool isCompleted,
  }) = _ChecklistItem;

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => _$ChecklistItemFromJson(json);
}
