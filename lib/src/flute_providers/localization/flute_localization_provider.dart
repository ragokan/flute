import 'package:flutter/material.dart';

import '../../../flute.dart';
import 'flute_language_base.dart';

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
abstract class FluteLocalizationProvider<T extends FluteLanguageBase>
    extends FluteNotifier<T> {
  final String kLocaleKey = 'kLocaleKey';

  FluteLocalizationProvider(T language) : super(language) {
    // Get data from save
    setLocale(FluteStorage.get<String>('locale'));
  }

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
