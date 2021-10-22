import 'package:flute/flute.dart';

typedef StatusCallback<T, X extends FluteProvider<S>, S> = T Function(S state);

mixin StatusProvider<X extends FluteProvider<S>, S> on FluteProvider<S> {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  T? when<T>({
    StatusCallback<T, X, S>? initial,
    StatusCallback<T, X, S>? loading,
    StatusCallback<T, X, S>? done,
    StatusCallback<T, X, S>? error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial?.call(state);
      case Status.loading:
        return loading?.call(state);
      case Status.done:
        return done?.call(state);
      case Status.error:
        return error?.call(state);
      default:
        return initial?.call(state);
    }
  }
}
