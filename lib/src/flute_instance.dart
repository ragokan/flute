import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../flute.dart';
import 'flute_utilities/index.dart';

/// The implementation of [Flute].
///
/// We use it as a private class because it is not optimal to have multiple
/// Flute classes.
class _Flute
    with
        FluteWidgets,
        FluteDevice,
        FluteRouting,
        FluteDependencyInjection,
        FluteFunctions {
  @override

  /// The [NavigatorState] of the app.
  /// You can use this to provide data to your material app.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// The [BuildContext]:[context] of your app.
  /// If you don't use [FluteMaterialApp]-[FluteCupertinoApp] or
  /// provide [navigatorKey] to the your app, it will throw an exception.
  @override
  BuildContext get context => navigatorKey.currentContext!;

  /// Current route name
  /// For example: '/users/flute/31'
  String? routeName;

  /// Arguments of your current route.
  /// It will always be a Map.
  ///
  /// When you go to a new route and for example do this:
  /// ```dart
  /// Flute.pushNamed('/users',arguments:22)
  ///
  /// // The result will be:
  /// Flute.arguments = {'arguments': 22};
  ///
  /// // So, to use it
  /// final id = Flute.arguments['arguments'] as int;
  ///
  /// // The reason of doing it is dynamic routing.
  /// ```
  Map<String, dynamic> arguments = {};

  /// The root controller of your [FluteMaterialApp] or [FluteCupertinoApp].
  ///
  /// If you want, you can use this expression to use, too.
  ///
  /// ```dart
  /// Flute.use<AppController>(); // this is same as Flute.app;
  /// ```
  ///
  /// This controller is responsible for your app, you can use it to do
  /// almost anything with your app, even updating the whole app with
  /// update command.
  AppController get app => use<AppController>();

  _Flute() {
    /// We inject the [AppController] here, if the user doesn't use
    /// either of [FluteMaterialApp] or [FluteCupertinoApp], the features
    /// won't work.
    inject(AppController());
  }
}

/// The root of [Flute] library's utilities.
///
/// This class has shortcuts for routing, small utilities of context like
/// size of the device and has usage with widgets like show bottom modal sheet.
// ignore: non_constant_identifier_names
final _Flute Flute = _Flute();
