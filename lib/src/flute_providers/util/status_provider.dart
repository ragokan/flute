import 'package:flute/flute.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef StatusCallback<T, X extends FluteProvider<S>, S> = T Function(S state);
typedef StatusListenCallback<X extends FluteProvider<S>, S> = void Function(
    S state);

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

  VoidFunction listenWhen({
    StatusListenCallback<X, S>? initial,
    StatusListenCallback<X, S>? loading,
    StatusListenCallback<X, S>? done,
    StatusListenCallback<X, S>? error,
    bool callImmediately = true,
  }) {
    void _listener() {
      switch (_status) {
        case Status.initial:
          initial?.call(state);
          break;
        case Status.loading:
          loading?.call(state);
          break;
        case Status.done:
          done?.call(state);
          break;
        case Status.error:
          error?.call(state);
          break;
        default:
          initial?.call(state);
          break;
      }
    }

    addListener(_listener);

    if (callImmediately) {
      _listener();
    }

    return () => removeListener(_listener);
  }
}
