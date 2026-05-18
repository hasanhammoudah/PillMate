import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../features/medications/domain/models/medication_model.dart';
import '../helpers/alarm_helper.dart';
import 'notification_service.dart';

/// High-level API for scheduling and cancelling medication reminders.
/// Wraps [NotificationService] with medication-domain logic.
class ReminderService {
  ReminderService._();
  static final ReminderService instance = ReminderService._();

  final _notif = NotificationService.instance;

  // ── Schedule ────────────────────────────────────────────────────────────────

  /// Schedules a daily notification for every time slot in [medication].
  Future<void> scheduleForMedication(Medication medication) async {
    debugPrint('[ReminderService] scheduleForMedication: "${medication.name}"');
    debugPrint('[ReminderService]   Times: ${medication.scheduleTimes}');

    if (medication.scheduleTimes.isEmpty) {
      debugPrint('[ReminderService] ⚠️  No times — nothing to schedule');
      return;
    }

    for (var i = 0; i < medication.scheduleTimes.length; i++) {
      final timeStr = medication.scheduleTimes[i];
      final parsed = AlarmHelper.parseTime(timeStr);
      if (parsed == null) {
        debugPrint(
            '[ReminderService] ❌ Invalid time format "$timeStr" — skipped');
        continue;
      }

      final id = AlarmHelper.notificationId(medication.id, i);

      final payloadData = <String, dynamic>{
        'notificationId': id,
        'medicationId': medication.id,
        'medicationName': medication.name,
        'dosage': medication.dosage,
        'scheduledTime': timeStr,
      };

      await _notif.scheduleDailyMedicationReminder(
        id: id,
        medicationName: medication.name,
        dosage: medication.dosage,
        hour: parsed.hour,
        minute: parsed.minute,
        payloadData: payloadData,
      );

      debugPrint(
          '[ReminderService] ✅ Scheduled "${medication.name}" at $timeStr (ID=$id)');
    }
  }

  // ── Cancel ──────────────────────────────────────────────────────────────────

  /// Cancels all scheduled reminders for [medication].
  Future<void> cancelForMedication(Medication medication) async {
    for (var i = 0; i < medication.scheduleTimes.length; i++) {
      final id = AlarmHelper.notificationId(medication.id, i);
      await _notif.cancel(id);
    }
    // Also cancel any pending snooze for this medication
    for (var i = 0; i < medication.scheduleTimes.length; i++) {
      final snoozeId = AlarmHelper.snoozeId(
          AlarmHelper.notificationId(medication.id, i));
      await _notif.cancel(snoozeId);
    }
    debugPrint(
        '[ReminderService] Cancelled all reminders for "${medication.name}"');
  }

  // ── Reschedule all (called on app start & after boot) ───────────────────────

  /// Cancels every existing notification then re-schedules all medications.
  /// Called on app init so reminders survive kills, updates, and reboots.
  Future<void> rescheduleAll(List<Medication> medications) async {
    await _notif.cancelAll();
    int scheduled = 0;
    for (final med in medications) {
      await scheduleForMedication(med);
      scheduled += med.scheduleTimes.length;
    }
    debugPrint(
        '[ReminderService] Rescheduled $scheduled reminders across ${medications.length} medications');
    await _notif.printPendingNotifications();
  }

  // ── Debug ───────────────────────────────────────────────────────────────────

  /// Prints a summary of all pending notifications — useful for QA testing.
  Future<void> debugPendingReminders() async {
    await _notif.printPendingNotifications();
  }

  /// Builds the payload map the way [NotificationService] expects it,
  /// exposed so the reminder screen can re-create it for manual tests.
  static Map<String, dynamic> buildPayload({
    required int notificationId,
    required String medicationId,
    required String medicationName,
    required String dosage,
    required String scheduledTime,
  }) =>
      {
        'notificationId': notificationId,
        'medicationId': medicationId,
        'medicationName': medicationName,
        'dosage': dosage,
        'scheduledTime': scheduledTime,
      };

  static Map<String, dynamic>? parsePayload(String? raw) {
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
