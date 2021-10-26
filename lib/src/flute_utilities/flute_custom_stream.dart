import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

class CustomFluteStream {
  final List<VoidFunction> _listeners = [];

  /// Notifies all listeners.
  void notifyListeners() {
    for (var listener in _listeners) {
      try {
        listener();
      } catch (error) {
        debugPrint(
            'Error happened while calling the listener: $listener - $error');
      }
    }
  }

  void listen(VoidFunction listener) {
    _listeners.add(listener);
  }

  void listenIfHasNoListeners(VoidFunction listener) {
    if (_listeners.isNotEmpty) return;
    _listeners.add(listener);
  }

  void removeListener(VoidFunction listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }
}
