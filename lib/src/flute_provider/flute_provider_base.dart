import 'package:flutter/material.dart';

/// Base of Flute state management.
class FluteProviderBase extends Listenable {
  /// Notifies all listeners.
  void update() {
    if (_disposed) return;
    for (var listener in _listeners) {
      try {
        listener?.call();
      } catch (error) {
        print('Error happened while updating the FluteProvider: $error');
      }
    }
  }

  bool _disposed = false;

  final List<VoidCallback?> _listeners = [];

  @override
  void addListener(VoidCallback listener) {
    if (_disposed) return;
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    if (_disposed) return;
    _listeners.remove(listener);
  }

  /// Disposes the Provider, after that, it cannot be used.
  void dispose() {
    if (_disposed) return;
    _listeners.clear();
    _disposed = true;
  }
}
