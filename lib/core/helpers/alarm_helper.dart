class AlarmHelper {
  /// Generates a deterministic, collision-resistant notification ID for a given
  /// [medicationId] and [timeIndex] (position in scheduleTimes list).
  /// Stays within int32 safe range (max ~100 times per medication).
  static int notificationId(String medicationId, int timeIndex) {
    final hash = medicationId.hashCode.abs() % 99990;
    return hash * 10 + (timeIndex % 10);
  }

  /// Snooze notification ID is offset by 500_000 to avoid colliding with
  /// the regular daily notification ID.
  static int snoozeId(int originalId) => originalId + 500000;

  /// Parses "HH:MM" into hour and minute. Returns null if the format is wrong.
  static ({int hour, int minute})? parseTime(String timeStr) {
    final parts = timeStr.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour: hour, minute: minute);
  }

  static String formatTime(int hour, int minute) =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
}
