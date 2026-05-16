import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'core/localization/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final localeProvider = LocaleProvider();
  await localeProvider.init();

  runApp(
    LocaleNotifierWidget(
      notifier: localeProvider,
      child: const PillMateApp(),
    ),
  );
}
