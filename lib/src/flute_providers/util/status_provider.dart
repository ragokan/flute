import 'dart:async';

import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef _StatusCallback<T, X extends FluteProvider<S>, S> = T Function(S state);

mixin StatusProvider<X extends FluteProvider<S>, S> on StateNotifier<S> {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus, {bool shouldNotify = true}) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (shouldNotify) {
      _controller.add(null);
    }
  }

  T when<T>({
    required _StatusCallback<T, X, S> initial,
    required _StatusCallback<T, X, S> loading,
    required _StatusCallback<T, X, S> done,
    required _StatusCallback<T, X, S> error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial(state);
      case Status.loading:
        return loading(state);
      case Status.done:
        return done(state);
      case Status.error:
        return error(state);
      default:
        return initial(state);
    }
  }

  @protected
  void initStatusProvider() {
    _removeListener = addListener((_) => _controller.add(null));
  }

  VoidFunction? _removeListener;

  final StreamController _controller = StreamController.broadcast();
  Stream get statusStream => _controller.stream;

  @override
  void dispose() {
    _removeListener?.call();
    _controller.close();
    _controller.sink.close();
    super.dispose();
  }
}
