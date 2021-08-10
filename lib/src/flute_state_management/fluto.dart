import 'package:flutter/material.dart';

import '../../flute.dart';
import '../typedefs/callback_types.dart';
import 'builder.dart';

/// The [Fluto] and other Flutos are the way to use builders
/// with [Flute.inject()].
///
/// ```dart
/// // Usage is very simple as usual, actually the simplest.
/// Fluto<CounterController>(
///    (controller) => Text('${controller.count}'),
///   );
///
/// ```
// ignore: non_constant_identifier_names
Widget Fluto<T extends FluteController>(
  ControllerCallback<T> callback, {
  FilterCallback<T>? filter,
  T? inject,
}) {
  /// We get the controller here with dependency injection and provide it.
  if (inject != null) Flute.inject(inject);
  final _controller = Flute.use<T>();
  return FluteBuilder(
    controller: _controller,
    filter: filter,
    builder: () => callback(_controller),
  );
}
