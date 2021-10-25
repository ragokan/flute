import '../../flute.dart';

typedef _UpdateCallback<T> = T Function(T state);
typedef _ListenerCallback<T> = void Function(T state);

/// {@macro flute_provider}
class FluteProvider<T> extends FluteProviderBase {
  /// {@macro flute_provider}
  FluteProvider(this._state);

  T _state;

  /// The state which immutable.
  T get state => _state;

  /// To set the [state], you can use [set] method.
  ///
  /// Example:
  ///
  /// ```dart
  /// counterProvider.set(1);
  /// ```
  void set(T newState) {
    if (newState == _state) return;
    _state = newState;
    notifyListeners();
  }

  /// To update the [state], you can use [update] method.
  ///
  /// Example:
  ///
  /// ```dart
  /// counterProvider.update((state) => state + 1);
  /// ```
  void update(_UpdateCallback<T> callback) => set(callback(_state));

  /// Listens the state changes, similar to [addListener] and [removeListener]
  /// but it has access to the state.
  ///
  /// Example:
  ///
  /// ```dart
  /// final removeListener = counterProvider.listen((state) {
  ///   // This function is called whenever state changes.
  ///   debugPrint(state);
  ///  });
  ///
  /// // Call removeListener whenever you finish your job, maybe on dispose.
  /// removeListener();
  /// ```
  Function listen(
    _ListenerCallback<T> listener, {
    bool callImmediately = true,
  }) {
    void _listener() {
      listener(_state);
    }

    addListener(_listener);

    if (callImmediately) {
      _listener();
    }

    return () => removeListener(_listener);
  }
}
