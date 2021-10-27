import 'package:flutter/material.dart';

import '../../flute.dart';

/// You can use this widget with MultiProvider or alone.
class FluteProviderWidget<T extends FluteNotifier>
    extends ChangeNotifierProvider<T> {
  /// Create method creates the instance.
  FluteProviderWidget({
    Key? key,
    required Create<T> create,
    bool? lazy,
    TransitionBuilder? builder,
    Widget? child,
  }) : super(
          key: key,
          create: create,
          lazy: lazy,
          builder: builder,
          child: child,
        );

  /// If you already instantiated the instance, use this method instead
  /// to prevent having multiple instances of the class.
  FluteProviderWidget.value({
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
}
