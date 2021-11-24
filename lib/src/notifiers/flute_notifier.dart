import 'dart:async';
import 'package:flute/flute.dart';
import 'package:flute/src/notifiers/models/change_model.dart';
import 'package:flutter/material.dart';

part 'stream_notifier.dart';

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

  /// Emits the state. No equality check because of large data comparisions.
  /// Instead, just check if they are identicial or not.
  @protected
  @mustCallSuper
  void emit(State newState) {
    if (identical(newState, _state)) return;

    onChange(Change(currentState: _state, nextState: newState));

    _state = newState;

    for (final listener in _listeners) {
      try {
        listener(_state);
      } catch (error, stackTrace) {
        addError(error, stackTrace);
      }
    }
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
  void onError(Object error, StackTrace stackTrace) {}

  /// Disposes the notifier, removes the listeners.
  @mustCallSuper
  void dispose() {
    _listeners.clear();
  }
}
