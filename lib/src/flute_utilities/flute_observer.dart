import 'package:flutter/material.dart';
import '../../flute.dart';

/// For this file, I don't think that it is necessary to add detailed
/// documents for each function, so I will describe them here.
///
/// This page is important to set the arguments of routes when
/// the page changes.
///
/// We do set two variables here, [Flute.arguments!] and [Flute.routeName!]

/// Observer is the way to observe navigation in [Flute]
class FluteObserver extends NavigatorObserver {
  void _setVariables(Route? newRoute) {
    Flute.routeName =
        newRoute?.settings.name ?? ModalRoute.of(Flute.context)!.settings.name;

    /// Firstly, we do check that if we do have arguments from the
    /// dynamic routing like [id] : [31]
    ///
    /// If it exists, we set arguments as [Map<String,dynamic>]
    ///
    /// else we get the arguments and create our arguments map.
    if (newRoute?.settings.arguments.runtimeType.toString().contains('Map') ==
        true) {
      Flute.arguments = newRoute?.settings.arguments as Map<String, dynamic>;
    } else {
      Flute.arguments = {'arguments': newRoute?.settings.arguments};
    }
  }

  /// Whenever the user uses push functions, we set variables.
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _setVariables(route);
  }

  /// Whenever the user uses pop functions, we set variables.
  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setVariables(previousRoute ?? route);
  }

  /// Whenever the user removes the previous route, this function will be
  /// called and we set the variables.
  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _setVariables(previousRoute ?? route);
  }

  /// Whenever the user uses replace functions, we set variables.
  ///
  /// Example: [Flute.pushReplacementNamed(routeName)]
  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setVariables(newRoute);
  }
}
