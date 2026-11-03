import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

part 'rest_alerts.g.dart';

/// "Rest over" alert at the end of a rest timer, shown even when the phone
/// is locked (spec F5 acceptance). The timer itself runs from an end time, so
/// it stays right after the screen comes back on.
abstract interface class RestAlerts {
  Future<void> schedule(DateTime at, {required String title, required String body});
  Future<void> cancel();
}

class NoopRestAlerts implements RestAlerts {
  const NoopRestAlerts();

  @override
  Future<void> schedule(DateTime at, {required String title, required String body}) async {}

  @override
  Future<void> cancel() async {}
}

class LocalRestAlerts implements RestAlerts {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;
  bool _exact = false;
  static const _id = 4201;

  Future<void> _init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    _exact = await android?.canScheduleExactNotifications() ?? false;
    _ready = true;
  }

  @override
  Future<void> schedule(DateTime at, {required String title, required String body}) async {
    try {
      await _init();
      await _plugin.cancel(id: _id);
      await _plugin.zonedSchedule(
        id: _id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'rest_timer',
            'Rest timer',
            channelDescription: 'Tells you when your rest between sets is over',
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
          ),
          iOS: DarwinNotificationDetails(interruptionLevel: InterruptionLevel.timeSensitive),
        ),
        androidScheduleMode: _exact
            ? AndroidScheduleMode.exactAllowWhileIdle
            : AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (_) {
      // Alerts are a nicety: the in-app timer and haptic still work.
    }
  }

  @override
  Future<void> cancel() async {
    try {
      if (_ready) await _plugin.cancel(id: _id);
    } catch (_) {}
  }
}

@Riverpod(keepAlive: true)
RestAlerts restAlerts(Ref ref) => kIsWeb ? const NoopRestAlerts() : LocalRestAlerts();
