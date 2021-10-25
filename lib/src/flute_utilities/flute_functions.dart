import 'dart:async';

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
  Timer setTimeout(Duration duration, Function callback) =>
      Timer(duration, () => callback());

  /// [seconds] is the amount of time that Flute will wait to call
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
  Function setInterval(int seconds, Function callback) {
    final timer = Timer.periodic(Duration(seconds: seconds), (_) => callback());
    return timer.cancel;
  }
}
