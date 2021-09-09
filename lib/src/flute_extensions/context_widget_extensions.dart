import 'package:flutter/material.dart';

/// Widget extensions of [BuildContext]
extension ContextWidgetExtensions on BuildContext {
  /// Shows a [SnackBar] across all registered [Scaffold]s but instead of
  /// [SnackBar] widget, you can just give it a string.
  void showToast({
    required String text,
    Duration? duration,
    SnackBarAction? action,
    TextStyle? textStyle,
    Color? backgroundColor,
    SnackBarBehavior? behavior,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: textStyle,
        ),
        backgroundColor: backgroundColor,
        duration: duration ?? const Duration(seconds: 5),
        action: action,
        behavior: behavior,
      ),
    );
  }

  /// Shows a [SnackBar] across all registered [Scaffold]s.
  void showSnackBar({required SnackBar snackBar}) {
    ScaffoldMessenger.of(this).showSnackBar(snackBar);
  }

  /// Shows a modal material design bottom sheet.
  Future<T?> showModal<T>({
    required Widget child,
    Color? backgroundColor,
    Color? barrierColor,
    Clip? clipBehavior,
    double? elevation,
    bool enableDrag = false,
    bool isDismissible = true,
    bool isScrollControlled = false,
    RouteSettings? routeSettings,
    ShapeBorder? shape,
    AnimationController? transitionAnimationController,
    bool useRootNavigator = false,
    BoxConstraints? constraints,
  }) async =>
      showModalBottomSheet(
        context: this,
        builder: (_) => child,
        backgroundColor: backgroundColor,
        barrierColor: barrierColor,
        clipBehavior: clipBehavior,
        elevation: elevation,
        enableDrag: enableDrag,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        routeSettings: routeSettings,
        shape: shape,
        transitionAnimationController: transitionAnimationController,
        useRootNavigator: useRootNavigator,
        constraints: constraints,
      );
}
