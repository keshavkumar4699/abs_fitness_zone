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
  Future<void> schedule(DateTime at, RestAlertText text);
  Future<void> cancel();
}

/// What the alert says (from l10n; set by the player before a set is ticked).
class RestAlertText {
  const RestAlertText({this.title = '', this.body = '', this.channelName = '', this.channelDescription = ''});

  final String title;
  final String body;
  final String channelName;
  final String channelDescription;
}

class NoopRestAlerts implements RestAlerts {
  const NoopRestAlerts();

  @override
  Future<void> schedule(DateTime at, RestAlertText text) async {}

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
  Future<void> schedule(DateTime at, RestAlertText text) async {
    try {
      await _init();
      await _plugin.cancel(id: _id);
      await _plugin.zonedSchedule(
        id: _id,
        title: text.title,
        body: text.body,
        scheduledDate: tz.TZDateTime.from(at.toUtc(), tz.UTC),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'rest_timer',
            text.channelName,
            channelDescription: text.channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
          ),
          iOS: const DarwinNotificationDetails(interruptionLevel: InterruptionLevel.timeSensitive),
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
