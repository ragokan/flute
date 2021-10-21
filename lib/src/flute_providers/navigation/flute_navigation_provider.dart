import 'package:flutter/material.dart';

abstract class NavigationProvider {
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  NavigatorState get state => key.currentState!;
  BuildContext get context => key.currentContext!;
}
