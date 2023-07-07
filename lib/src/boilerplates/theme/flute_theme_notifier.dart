import 'package:flutter/material.dart';
import 'package:riverbloc/riverbloc.dart';

abstract class FluteThemeNotifier extends Cubit<ThemeData> {
  FluteThemeNotifier(ThemeData state) : super(state);

  void setMode(ThemeMode mode) {
    final newState = mode == ThemeMode.dark ? darkThemeData : lightThemeData;
    if (state == newState) {
      return;
    }
    emit(newState);
  }

  ThemeData get lightThemeData;
  ThemeData get darkThemeData;
}
