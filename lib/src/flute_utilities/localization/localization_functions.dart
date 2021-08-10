import '../../../flute.dart';

/// Uses your locale and translates the sentences.
///
/// Usage
///
/// ```dart
/// localizeSimple('hello');
/// ```
/// That simple
///
/// Check translation documents for this.
String localizeSimple(String key) {
  if (Flute.app.locale == null) return key;
  final _languageTranslations = Flute
          .app.translations[Flute.app.locale.toString()] ??
      Flute.app.translations[Flute.app.locale?.languageCode.toString()] ??
      Flute.app.translations[Flute.app.fallbackLocale.toString()] ??
      Flute.app.translations[Flute.app.fallbackLocale.languageCode.toString()];

  final _translate =
      _languageTranslations != null ? _languageTranslations[key] ?? key : key;
  return _translate;
}
