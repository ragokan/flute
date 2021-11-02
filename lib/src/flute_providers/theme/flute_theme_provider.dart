import 'package:flutter/material.dart';

import '../../../flute.dart';

abstract class FluteThemeProvider extends FluteProvider<ThemeData> {
  FluteThemeProvider(ThemeData state) : super(state);

  void setMode(ThemeMode mode) {
    final newState = mode == ThemeMode.dark ? darkThemeData : lightThemeData;
    if (state == newState) {
      return;
    }
    set(newState);
  }

  ThemeData get lightThemeData;
  ThemeData get darkThemeData;
}
