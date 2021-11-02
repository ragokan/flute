import 'package:flute/flute.dart';

typedef _StatusNotifierCallback<T, X extends FluteNotifier> = T Function();
typedef _StatusNotifierListenCallback = void Function();

mixin StatusNotifierProvider<X extends FluteNotifier> on FluteNotifier {
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
    required _StatusNotifierCallback<T, X> initial,
    required _StatusNotifierCallback<T, X> loading,
    required _StatusNotifierCallback<T, X> done,
    required _StatusNotifierCallback<T, X> error,
  }) {
    switch (_status) {
      case Status.initial:
        return initial();
      case Status.loading:
        return loading();
      case Status.done:
        return done();
      case Status.error:
        return error();
      default:
        return initial();
    }
  }

  T? maybeWhen<T>({
    _StatusNotifierCallback<T, X>? initial,
    _StatusNotifierCallback<T, X>? loading,
    _StatusNotifierCallback<T, X>? done,
    _StatusNotifierCallback<T, X>? error,
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

  VoidFunction listenWhen({
    _StatusNotifierListenCallback? initial,
    _StatusNotifierListenCallback? loading,
    _StatusNotifierListenCallback? done,
    _StatusNotifierListenCallback? error,
    bool callImmediately = true,
  }) {
    void _listener() {
      switch (_status) {
        case Status.initial:
          initial?.call();
          break;
        case Status.loading:
          loading?.call();
          break;
        case Status.done:
          done?.call();
          break;
        case Status.error:
          error?.call();
          break;
        default:
          initial?.call();
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
