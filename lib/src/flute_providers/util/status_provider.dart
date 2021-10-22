import 'package:flute/flute.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef StatusCallback<T> = T Function();

mixin StatusProviderBase on FluteProviderBase {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus) {
    if (_status == newStatus) return;
    _status = newStatus;
    notifyListeners();
  }

  T? when<T>({
    StatusCallback<T>? initial,
    StatusCallback<T>? loading,
    StatusCallback<T>? done,
    StatusCallback<T>? error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial?.call();
      case Status.loading:
        return loading?.call();
      case Status.done:
        return done?.call();
      case Status.error:
        return error?.call();
      default:
        return initial?.call();
    }
  }
}
