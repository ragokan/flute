import 'package:flutter/material.dart';

@immutable
abstract class FluteLanguageBase {
  const FluteLanguageBase();

  // Locale of language
  Locale get locale;
}
