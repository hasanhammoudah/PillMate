import 'dart:convert';
import 'dart:ui' show Color;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

import '../helpers/alarm_helper.dart';
import '../helpers/timezone_helper.dart';

// ── Payload contract ──────────────────────────────────────────────────────────

typedef NotificationTapCallback = void Function(Map<String, dynamic> payload);

// ── Background handler (top-level — required by flutter_local_notifications) ──

@pragma('vm:entry-point')
void onBackgroundNotificationResponse(NotificationResponse response) {
  debugPrint(
      '[Notification] Background action: ${response.actionId} | ${response.payload}');
  if (response.actionId == NotificationService.kRemindLaterAction) {
    NotificationService.instance._scheduleSnoozeFromPayload(response.payload);
  }
}

// ── NotificationService ───────────────────────────────────────────────────────

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  // ── Channel: changed to v2 so Android creates a FRESH channel.
  // The old channel (pillmate_medication_reminders) was stuck with a broken
  // sound reference (alert.mp3 not in res/raw). Android never updates an
  // existing channel, so we must use a new ID.
  static const String kChannelId = 'pillmate_med_v2';
  static const String kChannelName = 'Medication Reminders';
  static const String kChannelDesc =
      'Daily medication reminder alerts with sound and vibration';

  static const String kTakenAction = 'TAKEN';
  static const String kRemindLaterAction = 'REMIND_LATER';

  // ID reserved for the instant test notification
  static const int kTestInstantId = 99997;
  // ID reserved for the 1-minute test notification
  static const int kTestScheduledId = 99998;

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Called when the user taps the notification body (not an action button).
  NotificationTapCallback? onTap;

  // ── Init ────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (_initialized) return;

    // 1. Timezone — must come first so every scheduled time is correct
    tz_data.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      debugPrint('[Notification] ✅ Timezone: ${tzInfo.identifier}');
    } catch (e) {
      debugPrint('[Notification] ⚠️ Timezone error (using UTC): $e');
    }

    // 2. Plugin initialisation
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onForegroundResponse,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    // 3. Create the Android notification channel (v2 — default system sound)
    await _createAndroidChannel();

    _initialized = true;
    debugPrint('[Notification] ✅ Service initialised');
  }

  // ── Permission requests ─────────────────────────────────────────────────────

  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final notifGranted = await android.requestNotificationsPermission();
      // Opens Settings > Apps > PillMate > Alarms & Reminders on Android 12
      final alarmGranted = await android.requestExactAlarmsPermission();
      debugPrint(
          '[Notification] Android — notifications: $notifGranted | exact alarms: $alarmGranted');
    }

    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final granted =
          await ios.requestPermissions(alert: true, badge: true, sound: true);
      debugPrint('[Notification] iOS permissions granted: $granted');
    }
  }

  // ── Android channel (v2) ────────────────────────────────────────────────────

  Future<void> _createAndroidChannel() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin == null) return;

    // No custom sound: alert.mp3 is not yet in android/app/src/main/res/raw/.
    // Using the default system notification sound prevents channel creation
    // failures on devices where the raw resource is missing.
    // To enable a custom sound: add alert.mp3 to res/raw/ and set
    //   sound: const RawResourceAndroidNotificationSound('alert')
    const channel = AndroidNotificationChannel(
      kChannelId,
      kChannelName,
      description: kChannelDesc,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      ledColor: Color(0xFF3EC1C9),
    );

    await androidPlugin.createNotificationChannel(channel);
    debugPrint('[Notification] Android channel created: $kChannelId');
  }

  // ── Exact-alarm availability check ─────────────────────────────────────────

  /// Returns true if the device can fire exact alarms right now.
  /// If false, we fall back to inexact scheduling (fires within a few minutes).
  Future<bool> _canScheduleExact() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true; // iOS — always yes
    try {
      final result = await android.canScheduleExactNotifications();
      debugPrint('[Notification] canScheduleExact: $result');
      return result ?? false;
    } catch (e) {
      debugPrint('[Notification] canScheduleExact error: $e');
      return false;
    }
  }

  // ── Internal schedule helper ────────────────────────────────────────────────

  Future<void> _doZonedSchedule({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime tzDate,
    required String? payload,
    DateTimeComponents? matchComponents,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      kChannelId,
      kChannelName,
      channelDescription: kChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 600, 300, 600]),
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      actions: [
        const AndroidNotificationAction(
          kTakenAction,
          'تناولت الدواء ✓',
          showsUserInterface: false,
          cancelNotification: true,
        ),
        const AndroidNotificationAction(
          kRemindLaterAction,
          'ذكّرني بعد 10 دقائق',
          showsUserInterface: false,
          cancelNotification: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    final canExact = await _canScheduleExact();
    final mode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexact;

    debugPrint('[Notification] Scheduling — ID=$id | exact=$canExact');
    debugPrint('  Title    : $title');
    debugPrint('  Fire at  : $tzDate');
    debugPrint('  Timezone : ${TimezoneHelper.localTimezoneName}');
    debugPrint('  Repeat   : ${matchComponents != null}');

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDate,
        details,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: matchComponents,
      );
      debugPrint('[Notification] ✅ Scheduled ID=$id');
    } catch (e) {
      debugPrint('[Notification] ❌ Exact schedule failed ($e) — retrying inexact');
      // Fallback: inexact (fires within a few minutes of the target time)
      try {
        await _plugin.zonedSchedule(
          id,
          title,
          body,
          tzDate,
          details,
          androidScheduleMode: AndroidScheduleMode.inexact,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
          matchDateTimeComponents: matchComponents,
        );
        debugPrint('[Notification] ✅ Scheduled inexact ID=$id');
      } catch (e2) {
        debugPrint('[Notification] ❌ All scheduling failed for ID=$id: $e2');
      }
    }
  }

  // ── Schedule daily repeating medication reminder ────────────────────────────

  Future<void> scheduleDailyMedicationReminder({
    required int id,
    required String medicationName,
    required String dosage,
    required int hour,
    required int minute,
    required Map<String, dynamic> payloadData,
  }) async {
    if (!_initialized) await init();

    final scheduled = TimezoneHelper.nextOccurrence(hour, minute);
    final payload = jsonEncode(payloadData);

    await _doZonedSchedule(
      id: id,
      title: '💊 تذكير بموعد الدواء',
      body:
          'حان الآن موعد تناول $medicationName${dosage.isNotEmpty ? ' — $dosage' : ''}',
      tzDate: scheduled,
      payload: payload,
      matchComponents: DateTimeComponents.time, // repeats daily
    );
  }

  // ── Snooze (one-time) ───────────────────────────────────────────────────────

  Future<void> scheduleSnoozeNotification({
    required int id,
    required String title,
    required String body,
    required DateTime at,
    required String payload,
  }) async {
    if (!_initialized) await init();
    final tzDate = TimezoneHelper.fromDateTime(at);
    await _doZonedSchedule(
      id: id,
      title: title,
      body: body,
      tzDate: tzDate,
      payload: payload,
    );
  }

  // ── Test helpers ────────────────────────────────────────────────────────────

  /// Fires an instant notification right now — no scheduling involved.
  /// Use this first to confirm the notification channel, permissions,
  /// and sound are all working before testing timed reminders.
  Future<void> showImmediateTestNotification() async {
    if (!_initialized) await init();

    debugPrint('[Notification] Showing immediate test notification…');

    final androidDetails = AndroidNotificationDetails(
      kChannelId,
      kChannelName,
      channelDescription: kChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 600, 300, 600]),
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
    );

    await _plugin.show(
      kTestInstantId,
      '💊 تجربة إشعار فورية',
      'الإشعارات تعمل بشكل صحيح! سيتم تذكيرك بمواعيد دوائك.',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );

    debugPrint('[Notification] ✅ Instant test notification sent');
  }

  /// Schedules a one-time test notification 1 minute from now.
  /// If this fires, the scheduler is working.
  /// If it does NOT fire, the problem is exact-alarm permission or Doze mode.
  Future<void> scheduleTestReminderIn1Minute() async {
    if (!_initialized) await init();

    final at = DateTime.now().add(const Duration(minutes: 1));
    final tzDate = TimezoneHelper.fromDateTime(at);

    debugPrint('[Notification] Scheduling 1-minute test…');
    debugPrint('  Fire at  : $at');
    debugPrint('  Timezone : ${TimezoneHelper.localTimezoneName}');
    debugPrint('  Local now: ${DateTime.now()}');

    await _doZonedSchedule(
      id: kTestScheduledId,
      title: '💊 اختبار التنبيه المجدول',
      body: 'نجح التنبيه المجدول بعد دقيقة واحدة ✅',
      tzDate: tzDate,
      payload: null,
      // No matchComponents → fires once, not daily
    );
  }

  // ── Cancel ──────────────────────────────────────────────────────────────────

  Future<void> cancel(int id) async {
    await _plugin.cancel(id);
    debugPrint('[Notification] Cancelled ID: $id');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('[Notification] All notifications cancelled');
  }

  // ── Debug ───────────────────────────────────────────────────────────────────

  Future<void> printPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    debugPrint('[Notification] Pending: ${pending.length}');
    for (final n in pending) {
      debugPrint('  → ID=${n.id} | ${n.title} | ${n.body}');
    }
  }

  // ── Response handlers ───────────────────────────────────────────────────────

  void _onForegroundResponse(NotificationResponse response) {
    debugPrint(
        '[Notification] Response: action=${response.actionId} | payload=${response.payload}');

    if (response.actionId == kTakenAction) {
      debugPrint('[Notification] Marked as taken');
      return;
    }
    if (response.actionId == kRemindLaterAction) {
      _scheduleSnoozeFromPayload(response.payload);
      return;
    }
    // Plain tap → navigate to reminder screen
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        onTap?.call(data);
      } catch (e) {
        debugPrint('[Notification] Payload parse error: $e');
      }
    }
  }

  void _scheduleSnoozeFromPayload(String? rawPayload) {
    if (rawPayload == null) return;
    try {
      final data = jsonDecode(rawPayload) as Map<String, dynamic>;
      final originalId = (data['notificationId'] as num?)?.toInt() ?? 0;
      final snoozeId = AlarmHelper.snoozeId(originalId);
      final medName = data['medicationName'] as String? ?? 'الدواء';

      scheduleSnoozeNotification(
        id: snoozeId,
        title: '💊 تذكير مؤجل',
        body: 'حان الآن موعد تناول $medName',
        at: DateTime.now().add(const Duration(minutes: 10)),
        payload: rawPayload,
      );
      debugPrint('[Notification] Snooze scheduled 10 min: $medName');
    } catch (e) {
      debugPrint('[Notification] Snooze error: $e');
    }
  }
}
