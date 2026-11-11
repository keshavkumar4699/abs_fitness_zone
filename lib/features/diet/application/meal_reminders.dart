import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

part 'meal_reminders.g.dart';

/// One daily reminder at a meal time (IST).
class MealReminder {
  const MealReminder({required this.index, required this.minutes, required this.title, required this.body});

  /// The meal's place in the day (0–8), so each meal keeps its own slot.
  final int index;

  /// Minutes after midnight.
  final int minutes;
  final String title;
  final String body;
}

/// Optional meal reminders (6.10): local notifications that repeat every
/// day at the times in the member's plan. Nothing leaves the phone.
abstract interface class MealReminders {
  /// The channel name and description show in Android's notification
  /// settings, so they come from l10n like everything else.
  Future<void> schedule(
    List<MealReminder> reminders, {
    required String channelName,
    required String channelDescription,
  });
  Future<void> cancelAll();
}

class NoopMealReminders implements MealReminders {
  const NoopMealReminders();

  @override
  Future<void> schedule(
    List<MealReminder> reminders, {
    required String channelName,
    required String channelDescription,
  }) async {}

  @override
  Future<void> cancelAll() async {}
}

class LocalMealReminders implements MealReminders {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  static const _base = 4300;

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _ready = true;
  }

  @override
  Future<void> schedule(
    List<MealReminder> reminders, {
    required String channelName,
    required String channelDescription,
  }) async {
    try {
      await _init();
      await cancelAll();
      final ist = tz.getLocation('Asia/Kolkata');
      final now = tz.TZDateTime.now(ist);
      for (final r in reminders) {
        var at = tz.TZDateTime(ist, now.year, now.month, now.day, r.minutes ~/ 60, r.minutes % 60);
        if (!at.isAfter(now)) at = at.add(const Duration(days: 1));
        await _plugin.zonedSchedule(
          id: _base + r.index,
          title: r.title,
          body: r.body,
          scheduledDate: at,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              'meal_reminders',
              channelName,
              channelDescription: channelDescription,
              importance: Importance.defaultImportance,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    } catch (_) {
      // Reminders are optional; the plan still works without them.
    }
  }

  @override
  Future<void> cancelAll() async {
    try {
      if (!_ready) await _init();
      for (var i = 0; i < 9; i++) {
        await _plugin.cancel(id: _base + i);
      }
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
MealReminders mealReminders(Ref ref) => kIsWeb ? const NoopMealReminders() : LocalMealReminders();
