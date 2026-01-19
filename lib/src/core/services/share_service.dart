import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';

class ShareService {
  Future<void> shareAsText(Note note) async {
    final text = '${note.title}\n\n${note.content}';
    await Share.share(
      text,
      subject: note.title.isEmpty ? 'Shared Note' : note.title,
    );
  }

  Future<void> copyToClipboard(Note note) async {
    final text = '${note.title}\n\n${note.content}';
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> shareChecklistAsText(Note note) async {
    if (!note.isChecklist) {
      await shareAsText(note);
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln(note.title);
    buffer.writeln();
    
    for (var item in note.checklistItems) {
      final checkbox = item.isCompleted ? '[x]' : '[ ]';
      buffer.writeln('$checkbox ${item.text}');
    }

    await Share.share(
      buffer.toString(),
      subject: note.title.isEmpty ? 'Shared Checklist' : note.title,
    );
  }
}
