import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kLangKey = 'language_code';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ar');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';
  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLangKey) ?? 'ar';
    _locale = Locale(code);
    // No notifyListeners — called before any listeners are attached.
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLangKey, locale.languageCode);
  }
}

// InheritedNotifier that makes LocaleProvider available anywhere in the tree.
class LocaleNotifierWidget extends InheritedNotifier<LocaleProvider> {
  const LocaleNotifierWidget({
    super.key,
    required LocaleProvider notifier,
    required super.child,
  }) : super(notifier: notifier);

  static LocaleProvider of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<LocaleNotifierWidget>()!
      .notifier!;
}
