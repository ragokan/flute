import 'package:flutter/material.dart';

import '../../../flute.dart';

/// Example
///
/// ```dart
/// abstract class LanguageBase implements FluteLanguageBase {
///   String get name;
/// }
///
/// class English implements LanguageBase {
///   @override
///   Locale get locale => const Locale('en');
///
///   @override
///   String get name => 'name';
/// }
///
/// class LocalizationProvider extends FluteLocalizationProvider<LanguageBase> {
///   LocalizationProvider(LanguageBase language) : super(language);
///
///   @override
///   Map<String, LanguageBase> get locales => {
///         'en': English(),
///       };
/// }
/// ```
abstract class FluteLocalizationNotifier<T extends FluteLanguageBase>
    extends FluteNotifier<T> {
  static const String kLocaleKey = 'kLocaleKey';

  FluteLocalizationNotifier(T language)
      : super(FluteStorage.get(kLocaleKey, defaultValue: language)!);

  // Add new locales here
  final Map<String, T> locales = const {};

  // Get current locale
  Locale get locale => state.locale;

  // Get supported locales
  Iterable<Locale> get supportedLocales =>
      locales.values.map((value) => value.locale);

  // Set new locale
  void setLocale(String? newLocale) {
    if (newLocale == null || newLocale == locale) return;
    emit(locales[newLocale]!);
    FluteStorage.put(kLocaleKey, newLocale);
  }
}
