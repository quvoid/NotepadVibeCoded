import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dart_vader_notes/src/features/notes/domain/entities/note.dart';

part 'notification_service.g.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // Initialize timezone
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to note
    // This will be handled by the router
    final noteId = response.payload;
    if (noteId != null) {
      // Navigation will be handled in main.dart
      print('Notification tapped for note: $noteId');
    }
  }

  Future<void> scheduleReminder(Note note) async {
    if (!_initialized) await init();
    if (note.reminderAt == null) return;

    final scheduledDate = tz.TZDateTime.from(note.reminderAt!, tz.local);
    
    // Don't schedule if time is in the past
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _notifications.zonedSchedule(
      note.id.hashCode, // Use note ID hash as notification ID
      note.title.isEmpty ? 'Note Reminder' : note.title,
      note.content.isEmpty ? 'You have a note to review' : note.content.substring(0, note.content.length > 100 ? 100 : note.content.length),
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'note_reminders',
          'Note Reminders',
          channelDescription: 'Reminders for your notes',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: note.id,
    );
  }

  Future<void> cancelReminder(String noteId) async {
    if (!_initialized) await init();
    await _notifications.cancel(noteId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    if (!_initialized) await init();
    await _notifications.cancelAll();
  }
}

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}
