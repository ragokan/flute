part of 'flute_notifier.dart';

/// Available statusses.
enum Status {
  initial,
  loading,
  done,
  error,
}

typedef _StatusCallback<T, State> = T Function(State state);

/// Helps notifier to have statusses like loading or done.
///
/// Especially because [FluteNotifier] provides immutable state management,
/// it helps a lot.
mixin StatusNotifier<State> on FluteNotifier<State> {
  Status _status = Status.initial;

  /// Current status.
  Status get status => _status;

  /// To [emit] the status, if [shouldNotify] parameter is true(default), notifies
  /// the listeners.
  void emitStatus(Status newStatus, {bool shouldNotify = true}) {
    try {
      if (_status == newStatus) return;
      _status = newStatus;
      if (shouldNotify) {
        _streamController?.add(_state);
      }
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  /// Run the given functions according to the current [status].
  T when<T>({
    required _StatusCallback<T, State> initial,
    required _StatusCallback<T, State> loading,
    required _StatusCallback<T, State> done,
    required _StatusCallback<T, State> error,
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

  /// Run the given functions according to the current [status] but it is not
  /// required to call all of them.
  T maybeWhen<T>({
    _StatusCallback<T, State>? initial,
    _StatusCallback<T, State>? loading,
    _StatusCallback<T, State>? done,
    _StatusCallback<T, State>? error,
    required _StatusCallback<T, State> orElse,
  }) {
    T runSafe(_StatusCallback<T, State>? callback) =>
        callback != null ? callback(state) : orElse(state);

    switch (_status) {
      case Status.initial:
        return runSafe(initial);
      case Status.loading:
        return runSafe(loading);
      case Status.done:
        return runSafe(done);
      case Status.error:
        return runSafe(error);
      default:
        return orElse(state);
    }
  }
}
