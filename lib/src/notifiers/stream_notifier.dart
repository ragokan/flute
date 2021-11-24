part of 'flute_notifier.dart';

mixin StreamNotifier<State> on FluteNotifier<State> {
  /// Private [StreamController] to notify the listeners.
  StreamController<State>? _streamController;

  /// A way to listen the state changes, also can be used with [StreamBuilder].
  Stream<State> get stream =>
      (_streamController ??= StreamController<State>.broadcast()).stream;

  @override
  void onChange(Change<State> change) {
    assert(() {
      if (_streamController?.isClosed ?? false) {
        throw Exception('Tried to emit state of $runtimeType after dispose.');
      }
      return true;
    }());
    try {
      _streamController?.add(change.nextState);
    } catch (error, stackTrace) {
      addError(error, stackTrace);
    }
    super.onChange(change);
  }

  @override
  Future<void> dispose() async {
    assert(() {
      if (_streamController?.isClosed ?? false) {
        throw Exception('Tried to dispose $runtimeType after dispose.');
      }
      return true;
    }());
    await _streamController?.close();
    super.dispose();
  }
}
