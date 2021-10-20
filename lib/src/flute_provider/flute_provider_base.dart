import 'package:flutter/material.dart';

/// Base of Flute state management.
class FluteProviderBase implements Listenable {
  final List<VoidCallback> _listeners = [];

  /// Notifies all listeners.
  void notifyListeners() {
    for (var listener in _listeners) {
      try {
        listener();
      } catch (error) {
        print('Error happened while updating the FluteProvider: $error');
      }
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Disposes the Provider, after that, it cannot be used.
  void dispose() {
    _listeners.clear();
  }
}
