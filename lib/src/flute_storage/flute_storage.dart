import 'package:flute/flute.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// The implementation of [FluteStorage]
class _FluteStorage {
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
    void Function(T? value) callback, {
    bool callImmediately = true,
  }) {
    final _stream = _box.watch(key: key).listen((e) => callback(e.value));

    if (callImmediately) {
      callback(read<T>(key));
    }

    return _stream.cancel;
  }

  late final Box _box;

  /// Returns true if the storage contains that key.
  bool contains(String key) => _box.containsKey(key);

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
  ///}
  ///```
  Future<void> init([String boxName = 'flute', String? subDir]) async {
    await Hive.initFlutter(subDir);
    _box = await Hive.openBox(boxName);
  }

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
  T? read<T>(String key) => _box.get(key);

  // List readAll() => _box.valuesBetween().toList();

  /// Writes a value to the storage with a key.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.write<String>('myName','Flute');
  /// ```
  Future<void> write<T>(String key, T value) async =>
      await _box.put(key, value);

  /// Writes multiple data to the local storage.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.writeAll({'myName' : 'Flute', 'flute' : 'best'});
  /// ```
  Future<void> writeAll(Map<String, dynamic> data) async =>
      await _box.putAll(data);

  /// Add data to the storage with auto increment value.
  Future<void> add<T>(T data) async => await _box.add(data);

  /// Add multiple data to the storage with auto increment value.
  Future<void> addAll<T>(Iterable<T> data) async => await _box.addAll(data);

  /// Get all values.
  Iterable<dynamic> get values => _box.values;

  /// Get all keys.
  Iterable<dynamic> get keys => _box.keys;

  /// Gets values between two indexes.
  Iterable<dynamic> paginatedValues({
    int? startKey,
    int? endKey,
  }) =>
      _box.valuesBetween(startKey: startKey, endKey: endKey);

  /// Writes a value to the storage with a key if the key's value is null.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.removeKey('myName');
  /// ```
  Future<void> removeKey(String key) async => await _box.delete(key);

  /// Writes a value to the storage with a key if the key's value is null.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.removeKeys(['myName', 'flute']);
  /// ```
  Future<void> removeKeys(List<String> keys) async =>
      await _box.deleteAll(keys);

  /// Deletes all keys and values from the storage, the file
  /// will still stay at its location.
  Future<void> clearStorage() async => await _box.clear();

  /// Closes the storage.
  Future<void> close() async => await _box.close();

  /// Creates sub box instances
  Future<_FluteStorage> openBox(String boxName) async =>
      _FluteCustomStorage()._openBox(boxName);

  /// Gets sub box instances
  _FluteStorage getBox(String boxName) => _FluteCustomStorage()._get(boxName);
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

class _FluteCustomStorage extends _FluteStorage {
  _FluteStorage _get(String boxName) {
    _box = Hive.box(boxName);
    return this;
  }

  Future<_FluteStorage> _openBox(String boxName) async {
    _box = await Hive.openBox(boxName);
    return this;
  }
}
