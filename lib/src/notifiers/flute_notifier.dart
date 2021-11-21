import 'dart:async';
import 'package:flutter/material.dart';

part 'status_notifier.dart';

typedef _UpdateCallback<T> = T Function(T state);
typedef _ListenerCallback<T> = void Function(T state);

class FluteNotifier<T> {
  FluteNotifier(this._state);

  T _state;

  T get state => _state;

  final StreamController<T> _streamController = StreamController<T>.broadcast();

  Stream<T> get stream => _streamController.stream;

  void emit(T newState) {
    try {
      assert(!_streamController.isClosed,
          'Tried to use $runtimeType after dispose.');
      if (identical(newState, _state)) return;
      _state = state;
      _streamController.add(_state);
    } catch (error, stackTrace) {
      onError(error, stackTrace);
      rethrow;
    }
  }

  void update(_UpdateCallback<T> callback) => emit(callback(_state));

  StreamSubscription<T> listen(
    _ListenerCallback<T> listener, {
    bool callImmediately = true,
  }) {
    if (callImmediately) {
      listener(_state);
    }
    return stream.listen(listener);
  }

  @mustCallSuper
  void onChange(T change) {}

  @mustCallSuper
  void addError(Object error, [StackTrace? stackTrace]) {
    onError(error, stackTrace ?? StackTrace.current);
  }

  @protected
  @mustCallSuper
  void onError(Object error, StackTrace stackTrace) {}

  @mustCallSuper
  Future<void> dispose() async {
    await _streamController.close();
  }
}
