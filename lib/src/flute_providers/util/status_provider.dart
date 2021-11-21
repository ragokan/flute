import 'package:flute/flute.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef _StatusCallback<T, X extends FluteNotifier<S>, S> = T Function(S state);

mixin StatusProvider<X extends FluteNotifier<S>, S> on FluteNotifier<S> {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus, {bool shouldNotify = true}) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (shouldNotify) {}
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
}
