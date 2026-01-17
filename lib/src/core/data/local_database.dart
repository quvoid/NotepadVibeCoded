import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dart_vader_notes/src/features/notes/data/models/note_model.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';

class LocalDatabase {
  static late Isar _isar;

  static Isar get instance => _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [NoteModelSchema],
      directory: dir.path,
      name: AppConstants.databaseName,
    );
  }
}
