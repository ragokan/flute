import 'package:flute/flute.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef _StatusCallback<T, X extends FluteProvider<S>, S> = T Function(S state);
typedef _StatusListenCallback<X extends FluteProvider<S>, S> = void Function(
    S state);

mixin StatusProvider<X extends FluteProvider<S>, S> on FluteProvider<S> {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus, {bool shouldNotify = true}) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (shouldNotify) {
      notifyListeners();
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

  T? maybeWhen<T>({
    _StatusCallback<T, X, S>? initial,
    _StatusCallback<T, X, S>? loading,
    _StatusCallback<T, X, S>? done,
    _StatusCallback<T, X, S>? error,
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
    _StatusListenCallback<X, S>? initial,
    _StatusListenCallback<X, S>? loading,
    _StatusListenCallback<X, S>? done,
    _StatusListenCallback<X, S>? error,
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
