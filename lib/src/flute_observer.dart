import 'package:flute/flute.dart';

abstract class FluteObserver {
  const FluteObserver();

  static FluteObserver? observer;

  void onNotifierError<State>(
    FluteNotifier<State> notifier, {
    required Object error,
    StackTrace? stackTrace,
  });

  void onStorageError(
    String type, {
    required Object error,
    StackTrace? stackTrace,
  });
}
