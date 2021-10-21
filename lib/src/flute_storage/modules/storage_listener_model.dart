typedef KeyCallback<T> = void Function(T? key);

/// The model for storage listeners.
///
/// Required for watch functions.
class StorageListener<T> {
  /// The key of storage to watch changes that calls [callback].
  final String? key;

  /// The callback function that is called when the listened [key] changes.
  final KeyCallback<T> callback;

  /// The Constructor of [StorageListener], and luckily it is constant!
  const StorageListener({this.key, required this.callback});
}
