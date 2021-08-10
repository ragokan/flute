import 'package:flutter/scheduler.dart';

/// A simple ticker provider mixin.
/// Usage:
///
/// ```dart
/// class YourController extends FluteController with FluteTickerProviderMixin{
///     // Now you can use your animation controllers here
///     // 'This' in vsync is the FluteTickerProviderMixin
///    TabController controller = TabController(vsync: this, length:3);
///   }
/// ```
mixin FluteTickerProviderMixin implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

/// For newer versions of Flutter, you can just use this;
/// ```dart
///    TabController controller =
///             TabController(vsync: FluteTickerProvider(), length:3);
/// ```
class FluteTickerProvider with FluteTickerProviderMixin {}
