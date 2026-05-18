import 'package:timezone/timezone.dart' as tz;

class TimezoneHelper {
  /// Returns the next [tz.TZDateTime] for the given [hour]:[minute] in local
  /// timezone. If that time has already passed today, it returns tomorrow's.
  static tz.TZDateTime nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now.add(const Duration(seconds: 5)))) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static String get localTimezoneName => tz.local.name;

  static tz.TZDateTime fromDateTime(DateTime dt) =>
      tz.TZDateTime.from(dt, tz.local);
}
