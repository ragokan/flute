import 'package:flutter/material.dart';

mixin FluteNotifier {
  int _count = 0;
  List<VoidCallback?> _listeners = List<VoidCallback?>.filled(0, null);
  int _notificationCallStackDepth = 0;
  int _reentrantlyRemovedListeners = 0;

  bool get hasListeners => _count > 0;

  void addListener(VoidCallback listener) {
    if (_count == _listeners.length) {
      if (_count == 0) {
        _listeners = List<VoidCallback?>.filled(1, null);
      } else {
        final newListeners =
            List<VoidCallback?>.filled(_listeners.length * 2, null);
        for (var i = 0; i < _count; i++) {
          newListeners[i] = _listeners[i];
        }
        _listeners = newListeners;
      }
    }
    _listeners[_count++] = listener;
  }

  void _removeAt(int index) {
    _count -= 1;
    if (_count * 2 <= _listeners.length) {
      final newListeners = List<VoidCallback?>.filled(_count, null);

      for (var i = 0; i < index; i++) {
        newListeners[i] = _listeners[i];
      }

      for (var i = index; i < _count; i++) {
        newListeners[i] = _listeners[i + 1];
      }

      _listeners = newListeners;
    } else {
      for (var i = index; i < _count; i++) {
        _listeners[i] = _listeners[i + 1];
      }
      _listeners[_count] = null;
    }
  }

  void removeListener(VoidCallback listener) {
    for (var i = 0; i < _count; i++) {
      final _listener = _listeners[i];
      if (_listener == listener) {
        if (_notificationCallStackDepth > 0) {
          _listeners[i] = null;
          _reentrantlyRemovedListeners++;
        } else {
          _removeAt(i);
        }
        break;
      }
    }
  }

  @mustCallSuper
  void dispose() {
    _listeners = List<VoidCallback?>.filled(0, null);
  }

  @protected
  @visibleForTesting
  @pragma('vm:notify-debugger-on-exception')
  void notifyListeners() {
    if (_count == 0) return;

    _notificationCallStackDepth++;

    final end = _count;
    for (var i = 0; i < end; i++) {
      try {
        _listeners[i]?.call();
      } catch (error) {
        debugPrint(error.toString());
      }
    }

    _notificationCallStackDepth--;

    if (_notificationCallStackDepth == 0 && _reentrantlyRemovedListeners > 0) {
      final newLength = _count - _reentrantlyRemovedListeners;
      if (newLength * 2 <= _listeners.length) {
        final newListeners = List<VoidCallback?>.filled(newLength, null);

        var newIndex = 0;
        for (var i = 0; i < _count; i++) {
          final listener = _listeners[i];
          if (listener != null) {
            newListeners[newIndex++] = listener;
          }
        }

        _listeners = newListeners;
      } else {
        for (var i = 0; i < newLength; i += 1) {
          if (_listeners[i] == null) {
            var swapIndex = i + 1;
            while (_listeners[swapIndex] == null) {
              swapIndex += 1;
            }
            _listeners[i] = _listeners[swapIndex];
            _listeners[swapIndex] = null;
          }
        }
      }

      _reentrantlyRemovedListeners = 0;
      _count = newLength;
    }
  }
}
