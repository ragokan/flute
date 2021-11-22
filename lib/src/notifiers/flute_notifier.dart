import 'dart:async';
import 'package:flute/src/notifiers/models/change_model.dart';
import 'package:flutter/material.dart';

part 'status_notifier.dart';

typedef _UpdateCallback<State> = State Function(State state);
typedef _ListenerCallback<State> = void Function(State state);

/// {@template flute_notifier}
/// Bloc but with some changes and adaptation for riverpod.
/// {@endtemplate}
abstract class FluteNotifier<State> {
  /// {@macro flute_notifier}
  FluteNotifier(this._state);

  /// Protect the state, never emit it.
  State _state;

  State get state => _state;

  /// Private [StreamController] to notify the listeners.
  final StreamController<State> _streamController =
      StreamController<State>.broadcast();

  /// Main way to listen the state changes, also can be used with [StreamBuilder].
  Stream<State> get stream => _streamController.stream;

  /// Emits the state. No equality check because of large data comparisions.
  /// Instead, just check if they are identicial or not.
  @protected
  @mustCallSuper
  void emit(State newState) {
    try {
      assert(!_streamController.isClosed,
          'Tried to use $runtimeType after dispose.');
      if (identical(newState, _state)) return;
      onChange(Change(currentState: _state, nextState: newState));
      _state = newState;
      _streamController.add(_state);
    } catch (error, stackStaterace) {
      onError(error, stackStaterace);
      rethrow;
    }
  }

  /// Emits the state silently, without notifying the controller.
  /// Instead, just check if they are identicial or not.
  @protected
  @mustCallSuper
  void emitSilently(
    State newState, {
    bool callOnChange = false,
  }) {
    try {
      assert(!_streamController.isClosed,
          'Tried to use $runtimeType after dispose.');
      if (identical(newState, _state)) return;
      if (callOnChange) {
        onChange(Change(currentState: _state, nextState: newState));
      }
      _state = newState;
    } catch (error, stackStaterace) {
      onError(error, stackStaterace);
      rethrow;
    }
  }

  @protected
  @mustCallSuper
  void update(_UpdateCallback<State> callback) => emit(callback(_state));

  /// Regular listen method of stream but with [callImmediately] parameter.
  @mustCallSuper
  StreamSubscription<State> listen(
    _ListenerCallback<State> listener, {
    bool callImmediately = true,
  }) {
    if (callImmediately) {
      listener(_state);
    }
    return stream.listen(listener);
  }

  /// Called before the state is emitted.
  @protected
  @mustCallSuper
  void onChange(Change<State> change) {}

  /// Can add errors, so that we can handle with [onError].
  @protected
  @mustCallSuper
  void addError(Object error, [StackTrace? stackStaterace]) {
    onError(error, stackStaterace ?? StackTrace.current);
  }

  /// Called whenever error occurs.
  @protected
  @mustCallSuper
  void onError(Object error, StackTrace stackStaterace) {}

  /// Disposes the notifier, closes the stream.
  @mustCallSuper
  Future<void> dispose() async {
    assert(!_streamController.isClosed,
        'Tried to dispose $runtimeType after dispose.');
    await _streamController.close();
  }
}
