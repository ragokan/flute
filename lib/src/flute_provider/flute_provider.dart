import '../../flute.dart';

typedef _UpdateCallback<T> = T Function(T state);

/// {@macro flute_provider}
class FluteProvider<T> extends StateNotifier<T> {
  /// {@macro flute_provider}
  FluteProvider(this._state) : super(_state);

  T _state;

  /// The state which immutable.
  @override
  T get state => _state;

  /// To set the [state], you can use [set] method.
  ///
  /// Example:
  ///
  /// ```dart
  /// counterProvider.set(1);
  /// ```
  void set(T newState) {
    if (identical(state, newState)) return;
    _state = newState;
  }

  /// To update the [state], you can use [update] method.
  ///
  /// Example:
  ///
  /// ```dart
  /// counterProvider.update((state) => state + 1);
  /// ```
  void update(_UpdateCallback<T> callback) => set(callback(_state));
}
