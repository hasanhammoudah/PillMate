import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale, this._strings);

  final Locale locale;
  final Map<String, String> _strings;

  // Primary access point used by the context extension below.
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  // Translate key; replace {placeholder} tokens with values from [args].
  String translate(String key, {Map<String, String>? args}) {
    String text = _strings[key] ?? key;
    if (args != null) {
      args.forEach((k, v) => text = text.replaceAll('{$k}', v));
    }
    return text;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ar', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final raw = await rootBundle
        .loadString('assets/translations/${locale.languageCode}.json');
    final Map<String, dynamic> map = json.decode(raw);
    return AppLocalizations(locale, map.map((k, v) => MapEntry(k, '$v')));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// ── Context helpers ──────────────────────────────────────────────────────────

extension AppLocalizationsX on BuildContext {
  /// Shorthand for AppLocalizations.of(context).translate(key).
  String tr(String key, {Map<String, String>? args}) =>
      AppLocalizations.of(this).translate(key, args: args);

  /// True when the active locale is Arabic.
  bool get isArabic => AppLocalizations.of(this).locale.languageCode == 'ar';

  /// Text direction derived from the active locale.
  TextDirection get appTextDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;
}
