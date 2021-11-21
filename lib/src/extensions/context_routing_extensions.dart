import 'package:flutter/material.dart';

/// Routing extensions of [BuildContext]
extension ContextRoutingExtensions on BuildContext {
  /// Equals to [Navigator.of(context).push()]
  /// Give it the [Route] you want to push
  ///
  /// Example
  /// ```dart
  /// context.push(MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  Future<T?> push<T>(Route<T> route) async => Navigator.of(this).push<T>(route);

  /// Similar to [Navigator.of(context).push()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushEasy(CounterPage());
  /// ```
  Future<T?> pushEasy<T>(
    Widget page, {
    RouteSettings? settings,
  }) async =>
      Navigator.of(this).push<T>(MaterialPageRoute(
        builder: (_) => page,
        settings: settings,
      ));

  /// Equals to [Navigator.of(context).push()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushNamed('/counterPage');
  /// ```
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) async =>
      Navigator.of(this).pushNamed<T>(
        routeName,
        arguments: arguments,
      );

  /// Equals to [Navigator.of(context).pushReplacement()]
  /// Just give it the [route] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushReplacement(
  ///    MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  ///
  Future<T?> pushReplacement<T, X>(
    Route<T> route, {
    X? result,
  }) async =>
      Navigator.of(this).pushReplacement<T, X>(route, result: result);

  /// Similar to [Navigator.of(context).pushReplacement()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushReplacementEasy(CounterPage());
  /// ```
  Future<T?> pushReplacementEasy<T, X>(
    Widget page, {
    X? result,
  }) async =>
      Navigator.of(this).pushReplacement<T, X>(
          MaterialPageRoute(builder: (_) => page),
          result: result);

  /// Equals to [Navigator.of(context).pushReplacementNamed()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushReplacementNamed('/counterPage');
  /// ```
  ///
  Future<T?> pushReplacementNamed<T, X>(
    String routeName, {
    Object? arguments,
  }) async =>
      Navigator.of(this).pushReplacementNamed<T, X>(
        routeName,
        arguments: arguments,
      );

  /// Equals to [Navigator.of(context).pushNamedAndRemoveUntil()]
  /// Just give it the [routeName] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushNamedAndRemoveUntil('/counterPage');
  /// ```
  Future<T?> pushNamedAndRemoveUntil<T>(
    String routeName, {
    Object? arguments,
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      Navigator.of(this).pushNamedAndRemoveUntil<T>(
        routeName,
        predicate ?? (_) => false,
        arguments: arguments,
      );

  /// Equals to [Navigator.of(context).pushAndRemoveUntil()]
  /// Just give it the [route] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushAndRemoveUntil(
  ///    MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  Future<T?> pushAndRemoveUntil<T>(
    Route<T> route, {
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        route,
        predicate ?? (_) => false,
      );

  /// Easier way of [Navigator.of(context).pushAndRemoveUntil()]
  /// Just give it the [page] you want to push
  ///
  /// Example
  /// ```dart
  /// context.pushEasyAndRemoveUntil(
  ///    MaterialPageRoute(builder: (context) => CounterPage()));
  /// ```
  Future<T?> pushEasyAndRemoveUntil<T>(
    Widget page, {
    bool Function(Route<dynamic>)? predicate,
  }) async =>
      Navigator.of(this).pushAndRemoveUntil<T>(
        MaterialPageRoute(builder: (_) => page),
        predicate ?? (_) => false,
      );

  /// Equals to [Navigator.of(context).pop()]
  ///
  /// Example
  /// ```dart
  /// context.pop();
  /// // You can also give it a result
  /// context.pop(result: 'Message sent successfully!');
  /// ```
  void pop<T>({T? result}) => Navigator.of(this).pop<T>(result);

  /// Equals to [Navigator.of(context).canPop()]
  ///
  /// Example
  /// ```dart
  /// bool? canPop = context.canPop();
  /// ```
  bool? canPop() => Navigator.of(this).canPop();

  /// Equals to [Navigator.of(context).maybePop()]
  Future<bool?> maybePop<T>([T? arguments]) async =>
      Navigator.of(this).maybePop<T>(arguments);

  /// Equals to [Navigator.of(context).popUntil()]
  void popUntil(String route) =>
      Navigator.of(this).popUntil(ModalRoute.withName(route));
}
