import 'dart:async';

import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

/// Flute provides easier ways to use utility functions.
///
/// I hope we can have more utility functions in future, the aim is to reduce
/// the code repeating.
mixin FluteFunctions {
  /// [duration] is the amount of time that Flute wait to call the function.
  /// after x amount of [duration], [callback] funciton will be called.
  ///
  /// Example
  ///
  /// ```dart
  /// Flute.setTimeout(5, () => debugPrint('5 second passed'));
  /// ```
  Timer setTimeout(Duration duration, VoidFunction callback) =>
      Timer(duration, () => callback());

  /// [duration] is the amount of time that Flute will wait to call
  /// the function again, it will continiously work.
  ///
  /// Returns a function that can stop the interval.
  ///
  /// Example
  ///
  /// ```dart
  /// final stopInterval = Flute.setInterval(5, () {
  ///   debugPrint('I will run every 5 seconds');
  /// });
  /// Flute.setTimeout(20, stopInterval);
  /// ```
  Function setInterval(Duration duration, VoidFunction callback) {
    final timer = Timer.periodic(duration, (_) => callback());
    return timer.cancel;
  }

  /// Example
  ///
  /// ```dart
  /// Flute.addPostFrameCallback(() {
  ///   print('Post frame callback');
  ///  });
  /// ```
  void addPostFrameCallback(VoidFunction callback) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => callback());
  }
}
