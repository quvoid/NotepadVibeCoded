import 'package:isar/isar.dart';

part 'note_model.g.dart';

@collection
class NoteModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uuid;

  late String title;

  late String content;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  bool isLocked = false;

  late String colorHex;
}
