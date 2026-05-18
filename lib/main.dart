import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/router/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'core/services/notification_service.dart';
import 'core/services/reminder_service.dart';
import 'features/medications/data/services/medication_local_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // 1. Initialize the notification plugin and timezone.
  await NotificationService.instance.init();

  // 2. Wire up the navigation callback so notification taps open the
  //    MedicationReminderScreen even when the app was cold-started.
  NotificationService.instance.onTap = (Map<String, dynamic> payload) {
    final medName = payload['medicationName'] as String? ?? '';
    final scheduledTime = payload['scheduledTime'] as String? ?? '';
    navigatorKey.currentState?.pushNamed(
      AppRoutes.medicationReminder,
      arguments: {
        'medicationName': medName,
        'scheduledTime': scheduledTime,
      },
    );
  };

  // 3. Re-schedule all saved medications on every app start.
  //    This recovers reminders after: app kill, phone restart, app update.
  try {
    final medications = await MedicationLocalService().getAll();
    await ReminderService.instance.rescheduleAll(medications);
  } catch (e) {
    debugPrint('[main] Reschedule error: $e');
  }

  // 5. Locale
  final localeProvider = LocaleProvider();
  await localeProvider.init();

  runApp(
    LocaleNotifierWidget(
      notifier: localeProvider,
      child: const PillMateApp(),
    ),
  );
}
