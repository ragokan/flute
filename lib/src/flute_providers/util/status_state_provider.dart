import 'dart:async';

import 'package:flute/flute.dart';

typedef _StatusCallback<T, X extends FluteStateNotifier<S>, S> = T Function(
    S state);

mixin StatusProvider<X extends FluteStateNotifier<S>, S>
    on FluteStateNotifier<S> {
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

  final StreamController _controller = StreamController.broadcast();
  Stream get statusStream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
    _controller.sink.close();
    super.dispose();
  }
}
