import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:dart_vader_notes/src/core/utils/constants.dart';
import 'package:dart_vader_notes/src/core/services/tts_service.dart';
import 'package:dart_vader_notes/src/core/services/share_service.dart';
import 'package:dart_vader_notes/src/core/services/notification_service.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/checklist_item.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/providers/note_providers.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/tts_controls.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/tag_selector.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/reminder_picker.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/note_stats_card.dart';
import 'package:dart_vader_notes/src/features/notes/presentation/widgets/checklist_editor.dart';
import 'package:dart_vader_notes/src/features/settings/data/pin_service.dart';

class NoteDetailScreen extends ConsumerStatefulWidget {
  final String noteId;

  const NoteDetailScreen({super.key, required this.noteId});

  @override
  ConsumerState<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends ConsumerState<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  Note? _existingNote;
  bool _isLoading = true;
  bool _isLocked = false;
  bool _isPinned = false;
  bool _isChecklist = false;
  List<String> _tags = [];
  List<ChecklistItem> _checklistItems = [];
  DateTime? _reminderAt;
  bool _showTtsControls = false;
  bool _showStats = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _loadNote();
  }

  Future<void> _loadNote() async {
    if (widget.noteId == 'new') {
      setState(() => _isLoading = false);
      return;
    }

    final result = await ref.read(noteRepositoryProvider).getNote(widget.noteId);
    
    result.fold(
      (failure) {
        if (mounted) context.pop();
      },
      (note) {
        if (mounted) {
          if (note != null) {
            _existingNote = note;
            _titleController.text = note.title;
            _contentController.text = note.content;
            _isLocked = note.isLocked;
            _isPinned = note.isPinned;
            _isChecklist = note.isChecklist;
            _tags = List.from(note.tags);
            _checklistItems = List.from(note.checklistItems);
            _reminderAt = note.reminderAt;
          }
          setState(() => _isLoading = false);
        }
      },
    );
  }

  Future<void> _saveNote() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty && _checklistItems.isEmpty) return;

    final title = _titleController.text;
    final content = _contentController.text;
    
    final note = _existingNote?.copyWith(
      title: title,
      content: content,
      isLocked: _isLocked,
      isPinned: _isPinned,
      isChecklist: _isChecklist,
      tags: _tags,
      checklistItems: _checklistItems,
      reminderAt: _reminderAt,
      updatedAt: DateTime.now(),
    ) ?? Note(
      id: const Uuid().v4(),
      title: title,
      content: content,
      isLocked: _isLocked,
      isPinned: _isPinned,
      isChecklist: _isChecklist,
      tags: _tags,
      checklistItems: _checklistItems,
      reminderAt: _reminderAt,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await ref.read(saveNoteProvider).call(note);
    
    // Schedule reminder if set
    if (_reminderAt != null) {
      await ref.read(notificationServiceProvider).scheduleReminder(note);
    }
  }

  Future<void> _deleteNote() async {
    if (_existingNote == null) return;
    
    // Soft delete
    final deletedNote = _existingNote!.copyWith(
      isDeleted: true,
      deletedAt: DateTime.now(),
    );
    await ref.read(saveNoteProvider).call(deletedNote);
    
    if (mounted) context.pop();
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(_isPinned ? 'Unpin note' : 'Pin note'),
              onTap: () {
                setState(() => _isPinned = !_isPinned);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.label_outline),
              title: const Text('Manage tags'),
              onTap: () {
                Navigator.pop(context);
                _showTagSelector();
              },
            ),
            ListTile(
              leading: const Icon(Icons.alarm),
              title: const Text('Set reminder'),
              onTap: () {
                Navigator.pop(context);
                _showReminderPicker();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () async {
                Navigator.pop(context);
                await _saveNote();
                if (_existingNote != null) {
                  final shareService = ShareService();
                  if (_isChecklist) {
                    await shareService.shareChecklistAsText(_existingNote!.copyWith(
                      title: _titleController.text,
                      checklistItems: _checklistItems,
                    ));
                  } else {
                    await shareService.shareAsText(_existingNote!.copyWith(
                      title: _titleController.text,
                      content: _contentController.text,
                    ));
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy),
              title: const Text('Copy to clipboard'),
              onTap: () async {
                Navigator.pop(context);
                await _saveNote();
                if (_existingNote != null) {
                  final shareService = ShareService();
                  await shareService.copyToClipboard(_existingNote!.copyWith(
                    title: _titleController.text,
                    content: _contentController.text,
                  ));
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text('Statistics'),
              onTap: () {
                Navigator.pop(context);
                setState(() => _showStats = !_showStats);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTagSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manage Tags'),
        content: TagSelector(
          selectedTags: _tags,
          onTagsChanged: (tags) => setState(() => _tags = tags),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showReminderPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Reminder'),
        content: ReminderPicker(
          initialDateTime: _reminderAt,
          onReminderChanged: (dateTime) => setState(() => _reminderAt = dateTime),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _saveNote(); // Auto-save on exit
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          // TTS button
          IconButton(
            icon: Icon(_showTtsControls ? Icons.volume_off : Icons.volume_up),
            tooltip: 'Voice read',
            onPressed: () => setState(() => _showTtsControls = !_showTtsControls),
          ),
          // Checklist toggle
          IconButton(
            icon: Icon(_isChecklist ? Icons.checklist : Icons.checklist_outlined),
            tooltip: 'Toggle checklist',
            onPressed: () => setState(() => _isChecklist = !_isChecklist),
          ),
          // More options
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: _showOptionsMenu,
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteNote,
          ),
          const SizedBox(width: 8),
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text('Private', style: TextStyle(fontSize: 16)),
            Switch(
              value: _isLocked,
              onChanged: (val) {
                if (val) {
                   final pinService = ref.read(pinServiceProvider);
                   if (!pinService.hasPin) {
                     ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                         content: const Text('Please set a PIN in Settings first'),
                         action: SnackBarAction(
                           label: 'Settings',
                           onPressed: () => context.push('/settings'),
                         ),
                       ),
                     );
                     return;
                   }
                }
                setState(() => _isLocked = val);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.p20),
          child: Column(
            children: [
              // TTS Controls
              if (_showTtsControls) ...[
                TtsControls(
                  text: '${_titleController.text} ${_contentController.text}',
                ),
                const SizedBox(height: 16),
              ],
              
              // Stats Card
              if (_showStats && _existingNote != null) ...[
                NoteStatsCard(
                  note: _existingNote!.copyWith(
                    title: _titleController.text,
                    content: _contentController.text,
                    checklistItems: _checklistItems,
                    isChecklist: _isChecklist,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              
              // Title
              TextField(
                controller: _titleController,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                maxLines: null,
                textInputAction: TextInputAction.next,
              ),
              
              // Content or Checklist
              if (_isChecklist)
                ChecklistEditor(
                  items: _checklistItems,
                  onItemsChanged: (items) => setState(() => _checklistItems = items),
                )
              else
                TextField(
                  controller: _contentController,
                  style: Theme.of(context).textTheme.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: 'Type something...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 10,
                  textAlignVertical: TextAlignVertical.top,
                ),
              
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _saveNote();
          if (mounted) {
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note Saved'), duration: Duration(seconds: 1)),
             );
             context.pop();
          }
        },
        label: const Text('Save'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
