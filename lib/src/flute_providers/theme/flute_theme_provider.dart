import 'package:flutter/material.dart';

import '../../../flute.dart';

abstract class FluteThemeProvider extends FluteProvider<ThemeData> {
  FluteThemeProvider(ThemeData state) : super(state);

  void setMode(ThemeMode mode) =>
      set(mode == ThemeMode.dark ? darkThemeData : lightThemeData);

  ThemeData get lightThemeData;
  ThemeData get darkThemeData;
}
