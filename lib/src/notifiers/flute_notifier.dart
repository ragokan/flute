import 'dart:async';
import 'package:flute/src/notifiers/models/change_model.dart';
import 'package:flutter/material.dart';

part 'status_notifier.dart';

typedef _UpdateCallback<State> = State Function(State state);
typedef _ListenerCallback<State> = void Function(State state);

class FluteNotifier<State> {
  FluteNotifier(this._state);

  State _state;

  State get state => _state;

  final StreamController<State> _streamController =
      StreamController<State>.broadcast();

  Stream<State> get stream => _streamController.stream;

  @protected
  @mustCallSuper
  void emit(State newState) {
    try {
      assert(!_streamController.isClosed,
          'Tried to use $runtimeType after dispose.');
      if (identical(newState, _state)) return;
      onChange(Change(currentState: _state, nextState: newState));
    } catch (error, stackStaterace) {
      onError(error, stackStaterace);
      rethrow;
    }
  }

  @protected
  @mustCallSuper
  void update(_UpdateCallback<State> callback) => emit(callback(_state));

  StreamSubscription<State> listen(
    _ListenerCallback<State> listener, {
    bool callImmediately = true,
  }) {
    if (callImmediately) {
      listener(_state);
    }
    return stream.listen(listener);
  }

  @protected
  @mustCallSuper
  void onChange(Change<State> change) {
    _state = change.nextState;
    _streamController.add(_state);
  }

  @protected
  @mustCallSuper
  void addError(Object error, [StackTrace? stackStaterace]) {
    onError(error, stackStaterace ?? StackTrace.current);
  }

  @protected
  @mustCallSuper
  void onError(Object error, StackTrace stackStaterace) {}

  @mustCallSuper
  Future<void> dispose() async {
    assert(!_streamController.isClosed,
        'Tried to dispose $runtimeType after dispose.');
    await _streamController.close();
  }
}
