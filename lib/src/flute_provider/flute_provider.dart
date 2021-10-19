import '../../flute.dart';

/// ChangeNotifier instance which has immutable state.
class FluteProvider<T> extends FluteProviderBase {
  /// While creating the instance, we define the state.
  FluteProvider(this.state);

  /// The state which immutable.
  ///
  T state;

  /// To set the [state], you can use [set] method.
  ///
  /// Example:
  ///
  /// ```dart
  /// counterProvider.set(5);
  /// ```
  void set(T newState) {
    if (newState == state) return;
    state = newState;
    update();
  }
}
