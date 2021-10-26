import 'package:flutter/material.dart';

typedef _TCallback<T> = void Function(T? value);

class FluteCustomValueStream<T> {
  final List<_TCallback<T>> _listeners = [];

  /// Notifies all listeners.
  void notifyListeners([T? value]) {
    for (var listener in _listeners) {
      try {
        listener(value);
      } catch (error) {
        debugPrint(
            'Error happened while calling the listener: $listener - $error');
      }
    }
  }

  void listen(_TCallback<T> listener) {
    _listeners.add(listener);
  }

  void removeListener(_TCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
  }
}
