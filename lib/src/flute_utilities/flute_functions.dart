import 'dart:async';
import 'localization/localization_functions.dart';

/// Flute provides easier ways to use utility functions.
///
/// I hope we can have more utility functions in future, the aim is to reduce
/// the code repeating.
mixin FluteFunctions {
  /// [seconds] is the amount of time that Flute wait to call the function.
  /// after x [seconds], [callback] funciton will be called.
  ///
  /// Example
  ///
  /// ```dart
  /// Flute.setTimeout(5, () => print('5 second passed'));
  /// ```
  void setTimeout(int seconds, Function callback) =>
      Timer(Duration(seconds: seconds), () => callback());

  /// [seconds] is the amount of time that Flute will wait to call
  /// the function again, it will continiously work.
  ///
  /// Returns a function that can stop the interval.
  ///
  /// Example
  ///
  /// ```dart
  /// final stopInterval = Flute.setInterval(5, () {
  ///   print('I will run every 5 seconds');
  /// });
  /// Flute.setTimeout(20, stopInterval);
  /// ```
  Function setInterval(int seconds, Function callback) {
    final timer = Timer.periodic(Duration(seconds: seconds), (_) => callback());
    return timer.cancel;
  }

  /// Uses your locale and translates the sentences.
  ///
  /// Usage
  ///
  /// ```dart
  /// Flute.localize('hello');
  /// ```
  /// That simple
  ///
  /// Check translation documents for this.
  String localize(String key) => localizeSimple(key);
}
