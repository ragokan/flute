import 'package:flutter/material.dart';

import '../../flute.dart';

/// You can use this widget with MultiProvider or alone.
class FluteProviderWidget<T extends FluteProviderBase>
    extends InheritedProvider<T> {
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
          dispose: _dispose,
          lazy: lazy,
          builder: builder,
          startListening: _startListening,
          child: child,
        );

  /// If you already instantiated the instance, use this method instead
  /// to prevent having multiple instances of the class.
  FluteProviderWidget.value({
    Key? key,
    required T value,
    bool? lazy,
    TransitionBuilder? builder,
    UpdateShouldNotify<T>? updateShouldNotify,
    Widget? child,
  }) : super.value(
          value: value,
          builder: builder,
          child: child,
          key: key,
          lazy: lazy,
          startListening: _startListening,
          updateShouldNotify: updateShouldNotify,
        );

  static void _dispose(BuildContext _, FluteProviderBase? notifier) =>
      notifier?.dispose();

  static VoidCallback _startListening(
    InheritedContext e,
    FluteProviderBase? value,
  ) {
    value?.addListener(e.markNeedsNotifyDependents);
    return () => value?.removeListener(e.markNeedsNotifyDependents);
  }
}
