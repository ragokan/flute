import 'package:flutter/material.dart';

import '../../flute.dart';

/// You can use this widget with MultiProvider or alone.
class FluteNotifierProvider<T extends FluteNotifier>
    extends ChangeNotifierProvider<T> {
  /// Create method creates the instance.
  FluteNotifierProvider({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
    bool inject = false,
  }) : super(
          key: key,
          create:
              inject ? (context) => Flute.inject<T>(create(context)) : create,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// If you already instantiated the instance, use this method instead
  /// to prevent having multiple instances of the class.
  FluteNotifierProvider.value({
    Key? key,
    required T value,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          value: value,
          builder: builder,
          child: child,
          key: key,
        );

  FluteNotifierProvider.injected({
    Key? key,
    TransitionBuilder? builder,
    Widget? child,
  }) : super.value(
          value: Flute.use<T>(),
          builder: builder,
          child: child,
          key: key,
        );
}
