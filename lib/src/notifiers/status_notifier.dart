part of 'flute_notifier.dart';

enum Status {
  initial,
  loading,
  done,
  error,
}

typedef _StatusCallback<T, X extends FluteNotifier<State>, State> = T Function(
    State state);

mixin StatusNotifier<X extends FluteNotifier<State>, State>
    on FluteNotifier<State> {
  Status _status = Status.initial;

  Status get status => _status;

  void setStatus(Status newStatus, {bool shouldNotify = true}) {
    if (_status == newStatus) return;
    _status = newStatus;
    if (shouldNotify) {
      _streamController.add(_state);
    }
  }

  T when<T>({
    required _StatusCallback<T, X, State> initial,
    required _StatusCallback<T, X, State> loading,
    required _StatusCallback<T, X, State> done,
    required _StatusCallback<T, X, State> error,
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
        throw UnimplementedError(
            'There are no $status suitable for the $when method!');
    }
  }
}
