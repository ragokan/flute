import 'dart:async';
import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

part 'status_notifier.dart';

typedef _ListenerCallback<State> = void Function(State state);

/// {@template flute_notifier}
/// Bloc but with some changes and adaptation for riverpod.
/// {@endtemplate}
abstract class FluteNotifier<State> {
  /// {@macro flute_notifier}
  FluteNotifier(this._state);

  final List<_ListenerCallback<State>> _listeners = [];

  /// Protect the state, never emit it.
  State _state;

  State get state => _state;

  /// Private [StreamController] to notify the listeners.
  StreamController<State>? _streamController;

  /// A way to listen the state changes, also can be used with [StreamBuilder].
  Stream<State> get stream =>
      (_streamController ??= StreamController<State>.broadcast()).stream;

  /// Emits the state. No equality check because of large data comparisions.
  /// Instead, just check if they are equal or not.
  @protected
  @mustCallSuper
  void emit(State newState) {
    assert(() {
      if (_streamController?.isClosed ?? false) {
        throw Exception('Tried to emit state of $runtimeType after dispose.');
      }
      return true;
    }());

    if (_state == newState) return;

    _state = newState;

    onChange(Change(currentState: _state, nextState: newState));

    for (final listener in _listeners) {
      try {
        listener(_state);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
        _listeners.remove(listener);
      }
    }

    _streamController?.sink.add(_state);
  }

  /// Listen the state changes
  @mustCallSuper
  VoidFunction listen(
    _ListenerCallback<State> listener, {
    bool callImmediately = true,
  }) {
    if (callImmediately) {
      listener(_state);
    }
    _listeners.add(listener);
    return () => _listeners.remove(listener);
  }

  /// Called before the state is emitted.
  @protected
  @mustCallSuper
  void onChange(Change<State> change) {}

  /// Can add errors, so that we can handle with [onError].
  @protected
  @mustCallSuper
  void addError(Object error, [StackTrace? stackTrace]) {
    onError(error, stackTrace ?? StackTrace.current);
  }

  /// Called whenever error occurs.
  @protected
  @mustCallSuper
  void onError(Object error, StackTrace stackTrace) {
    FluteObserver.observer
        ?.onNotifierError(this, error: error, stackTrace: stackTrace);
  }

  /// Disposes the notifier, removes the listeners.
  @mustCallSuper
  Future<void> dispose() async {
    assert(() {
      if (_streamController?.isClosed ?? false) {
        throw Exception('Tried to dispose $runtimeType after dispose.');
      }
      return true;
    }());

    _listeners.clear();

    await _streamController?.close();
  }
}
