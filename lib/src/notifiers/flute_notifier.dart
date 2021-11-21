import 'dart:async';
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

  void emit(State newState) {
    try {
      assert(!_streamController.isClosed,
          'Stateried to use $runtimeType after dispose.');
      if (identical(newState, _state)) return;
      _state = state;
      _streamController.add(_state);
    } catch (error, stackStaterace) {
      onError(error, stackStaterace);
      rethrow;
    }
  }

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

  @mustCallSuper
  void onChange(State change) {}

  @mustCallSuper
  void addError(Object error, [StackTrace? stackStaterace]) {
    onError(error, stackStaterace ?? StackTrace.current);
  }

  @protected
  @mustCallSuper
  void onError(Object error, StackTrace stackStaterace) {}

  @mustCallSuper
  Future<void> dispose() async {
    await _streamController.close();
  }
}
