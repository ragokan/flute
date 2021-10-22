import 'package:flutter/material.dart';

import '../../flute.dart';

class StateConsumer<T extends FluteProvider<X>, X> extends StatelessWidget {
  const StateConsumer({
    Key? key,
    required this.builder,
    Widget? child,
  }) : super(key: key);

  /// {@template provider.consumer.builder}
  /// Build a widget tree based on the value from a [Provider<T>].
  ///
  /// Must not be `null`.
  /// {@endtemplate}
  final Widget Function(BuildContext context, X value) builder;

  @override
  Widget build(BuildContext context) =>
      builder(context, context.watch<T>().state);
}
