// I learned this usage from https://github.com/gskinnerTeam/flutter-universal-platform/blob/master/lib/universal_platform.dart
// What it does it, if we have dart.library.io, which doesnt exists on web
// we import storage, else we import web.
import 'package:flute/flute.dart';

import 'modules/flute_web_storage.dart'
    if (dart.library.io) 'modules/flute_io_storage.dart';
import 'modules/storage_listener_model.dart';

/// The implementation of [FluteStorage]
///
/// The [ImplFluteStorage] depends on the import above.
class _FluteStorage extends ImplFluteStorage {
  final _listeners = <StorageListener>{};

  /// [_notify] is the method that notifies all listeners.
  void _notify([String? key]) => _listeners.forEach(
        (element) {
          if (key == null) {
            element.callback(null);
          } else if (element.key == key) {
            element.callback(read(key));
          }
        },
      );

  /// [listen] gives you a callback that called whenever the [key]
  /// you declared changes/creates.
  ///
  /// Usage
  ///
  /// ```dart
  /// listen<int>('count',(int count) => {
  ///   debugPrint('Count is changed to $count');
  /// });
  /// ```
  VoidFunction listen<T>(
    String key,
    KeyCallback<T> callback, {
    bool callImmediately = true,
  }) {
    final listener = StorageListener<T>(key: key, callback: callback);
    _listeners.add(listener);
    if (callImmediately) {
      listener.callback(read(key));
    }
    return () => _listeners.remove(listener);
  }

  /// [init] function is required to start [FluteStorage]
  ///
  /// The best practice to use it is using the function at the start of *main*
  /// function of your project.
  ///
  /// Example
  ///
  /// ```dart
  ///void main(List<String> arguments) {
  ///  await FluteStorage.init();
  /// // Rest of your code
  ///}
  ///```
  @override
  Future<void> init({String storageName = 'flute'}) async =>
      await super.init(storageName: storageName.trim());

  /// Reads the storage, if there are any match with the key, it returns
  /// the value of it. If there are no match, it will return null.
  ///
  /// You can give a type as its return type but it should match the
  /// written type.
  ///
  /// Usage
  ///
  /// ```dart
  /// final myName = FluteStorage.read<String>('myName');
  /// ```
  @override
  T? read<T>(String key) => super.read(key);

  /// Writes a value to the storage with a key.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.write<String>('myName','Flute');
  /// ```
  @override
  void write<T>(String key, T value) {
    super.write(key, value);
    _notify(key);
  }

  /// Writes multiple data to the local storage.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.writeMulti({'myName' : 'Flute', 'flute' : 'best'});
  /// ```
  @override
  void writeMulti(Map<String, dynamic> data) {
    super.writeMulti(data);
    data.keys.forEach(_notify);
  }

  /// Writes a value to the storage with a key if the key's value is null.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.removeKey('myName');
  /// ```
  @override
  void removeKey(String key) {
    super.removeKey(key);
    _notify(key);
  }

  /// Writes a value to the storage with a key if the key's value is null.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.removeKeys(['myName', 'flute']);
  /// ```
  @override
  void removeKeys(List<String> keys) {
    super.removeKeys(keys);
    keys.forEach(_notify);
  }

  /// Deletes all keys and values from the storage, the file
  /// will still stay at its location.
  @override
  void clearStorage() {
    super.clearStorage();
    _notify();
  }

  /// Deletes the file and data completely.
  @override
  void deleteStorage() {
    super.deleteStorage();
    _notify();
  }
}

/// [FluteStorage] is a local storage implementation for *Flute*.
///
/// Main methods are [FluteStorage.read()] and [FluteStorage.write(key, value)]
///
/// To use it, you should add this line to your main function.
///
/// ```dart
/// await FluteStorage.init();
/// ```
// ignore: non_constant_identifier_names
final _FluteStorage FluteStorage = _FluteStorage();
