import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../flute.dart';
import '../utilities/constants.dart';

/// This is actually the most important mixin of [Flute] class. It handles
/// all the routing and it has the [navigatorKey] property.
///
/// We have to override [navigatorKey] because as you know, mixins can't be
/// instantiated.
mixin FluteRouting {
  /// The [NavigatorState] of the app.
  /// You can use this to provide data to your material app.
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Instead of writing [navigatorKey.currentState!] and doing a check, we
  /// check it here. Moreover, we throw custom exception to the developer to
  /// provide the [navigatorKey] or use
  /// one of [FluteMaterialApp]-[FluteCupertinoApp].
  NavigatorState? get _state {
    if (navigatorKey.currentState == null) {
      throw Exception(nullException);
    }
    return navigatorKey.currentState;
  }

  /// Equals to [Navigator.of(context).push()]
  /// Give it the [Route] you want to push
  ///
  /// Example
  /// ```dart
  /// Flute.push(MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  Future<T?> push<T>(Route<T> route) async => _state?.push<T>(route);

  /// Similar to [Navigator.of(context).push()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushEasy(CounterPage());
  /// ```
  Future<T?> pushEasy<T>(Widget page) async =>
      _state?.push<T>(Flute.app.isMaterial
          ? MaterialPageRoute(builder: (_) => page)
          : CupertinoPageRoute(builder: (_) => page));

  /// Equals to [Navigator.of(context).push()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushNamed('/counterPage');
  /// // You can also add arguments as secondary parameter.
  /// ```
  ///
  /// Dynamic Routing:\
  /// In your [FluteMaterialApp] or [FluteCupertinoApp], you can add routes
  /// like ['/users/:id'] which will require a parameter, id.
  /// ```dart
  /// FluteMaterialApp(routes: {
  ///      '/': (ctx) => FirstPage(),
  ///      '/users/:id': (_) => UsersPage(),
  ///    });
  /// ```
  ///
  /// Then you can push to that route
  /// ```dart
  /// Flute.pushNamed('/users/31');
  /// ```
  ///
  /// Lastly in your app
  /// ```dart
  /// Flute.parameters['id']; => 31
  /// ```
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) async {
    return _state?.pushNamed<T>(
      routeName,
      arguments: arguments,
    );
  }

  /// Equals to [Navigator.of(context).pushReplacement()]
  /// Just give it the [route] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushReplacement(
  ///    MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  ///
  Future<T?> pushReplacement<T, X>(
    Route<T> route, {
    X? result,
  }) async =>
      _state?.pushReplacement<T, X>(route, result: result);

  /// Similar to [Navigator.of(context).pushReplacement()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushReplacementEasy(CounterPage());
  /// ```
  Future<T?> pushReplacementEasy<T, X>(
    Widget page, {
    X? result,
  }) async =>
      _state?.pushReplacement<T, X>(
          Flute.app.isMaterial
              ? MaterialPageRoute(builder: (_) => page)
              : CupertinoPageRoute(builder: (_) => page),
          result: result);

  /// Equals to [Navigator.of(context).pushReplacementNamed()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushReplacementNamed('/counterPage');
  /// // You can also add arguments as secondary parameter.
  /// ```
  ///
  /// Dynamic Routing:\
  /// In your [FluteMaterialApp] or [FluteCupertinoApp], you can add routes
  /// like ['/users/:id'] which will require a parameter, id.
  /// ```dart
  /// FluteMaterialApp(routes: {
  ///      '/': (ctx) => FirstPage(),
  ///      '/users/:id': (_) => UsersPage(),
  ///    });
  /// ```
  ///
  /// Then you can push to that route
  /// ```dart
  /// Flute.pushReplacementNamed('/users/31');
  /// ```
  ///
  /// Lastly in your app
  /// ```dart
  /// Flute.parameters['id']; => 31
  /// ```
  Future<T?> pushReplacementNamed<T, X>(
    String routeName, {
    Object? arguments,
  }) async =>
      _state?.pushReplacementNamed<T, X>(
        routeName,
        arguments: arguments,
      );

  /// Equals to [Navigator.of(context).pushNamedAndRemoveUntil()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushNamedAndRemoveUntil('/counterPage');
  /// // You can also add arguments as secondary parameter.
  /// ```
  ///  Not required but you can give it a [predicate]
  ///
  /// Dynamic Routing:\
  /// In your [FluteMaterialApp] or [FluteCupertinoApp], you can add routes
  /// like ['/users/:id'] which will require a parameter, id.
  /// ```dart
  /// FluteMaterialApp(routes: {
  ///      '/': (ctx) => FirstPage(),
  ///      '/users/:id': (_) => UsersPage(),
  ///    });
  /// ```
  ///
  /// Then you can push to that route
  /// ```dart
  /// Flute.pushNamedAndRemoveUntil('/users/31');
  /// ```
  ///
  /// Lastly in your app
  /// ```dart
  /// Flute.parameters['id']; => 31
  /// ```
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      _state?.pushNamedAndRemoveUntil<T>(
        routeName,
        predicate ?? (_) => false,
        arguments: arguments,
      );

  /// Equals to [Navigator.of(context).pushAndRemoveUntil()]
  /// Just give it the [route] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushAndRemoveUntil(
  ///    MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  ///  Not required but you can give it a [predicate]
  Future<T?> pushAndRemoveUntil<T>(
    Route<T> route, {
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      _state?.pushAndRemoveUntil<T>(
        route,
        predicate ?? (_) => false,
      );

  /// Easier way of [Navigator.of(context).pushAndRemoveUntil()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pushEasyAndRemoveUntil(
  ///    MaterialPageRoute(CounterPage()));
  /// ```
  ///  Not required but you can give it a [predicate]
  Future<T?> pushEasyAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      _state?.pushAndRemoveUntil<T>(
        Flute.app.isMaterial
            ? MaterialPageRoute(builder: (_) => page)
            : CupertinoPageRoute(builder: (_) => page),
        predicate ?? (_) => false,
      );

  /// Equals to [Navigator.of(context).pop()]
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// Flute.pop();
  /// // You can also give it a result
  /// Flute.pop(result: 'Message sent successfully!');
  /// ```
  void pop<T>({T? result}) => _state?.pop<T>(result);

  /// Equals to [Navigator.of(context).canPop()]
  ///
  /// Example
  /// ```dart
  /// // That Simple!
  /// bool? canPop = Flute.canPop();
  /// ```
  bool? canPop() => _state?.canPop();

  /// Equals to [Navigator.of(context).maybePop()]
  Future<bool?> maybePop<T>([T? arguments]) async =>
      _state?.maybePop<T>(arguments);

  /// Equals to [Navigator.of(context).popUntil()]
  void popUntil(String route) => _state?.popUntil(ModalRoute.withName(route));
}
