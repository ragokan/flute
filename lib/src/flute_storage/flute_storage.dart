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
      callback(get<T>(key));
    }

    return _stream.cancel;
  }

  late final Box _box;

  /// Returns true if the storage contains that key.
  bool containsKey(String key) => _box.containsKey(key);

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
    try {
      await Hive.initFlutter(subDir);

      _box = await Hive.openBox(boxName);
    } catch (e) {
      await Hive.close().catchError((_) {});
      await Hive.deleteBoxFromDisk(boxName).catchError((_) {});
      await Hive.initFlutter(subDir).catchError((_) {});
      _box = await Hive.openBox(boxName);
    }
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
  /// final myName = FluteStorage.get<String>('myName');
  /// ```
  T? get<T>(String key, {T? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue);

  // List readAll() => _box.valuesBetween().toList();

  /// Writes a value to the storage with a key.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.put<String>('myName','Flute');
  /// ```
  Future<void> put<T>(String key, T value) async => await _box.put(key, value);

  /// Writes a value to the storage with a key if it doesn't exists.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.putIfAbsent<String>('myName','Flute');
  /// ```
  Future<void> putIfAbsent<T>(String key, T value) async {
    if (_box.containsKey(key)) return;
    await _box.put(key, value);
  }

  /// Writes multiple data to the local storage.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.putAll({'myName' : 'Flute', 'flute' : 'best'});
  /// ```
  Future<void> putAll(Map<String, dynamic> data) async =>
      await _box.putAll(data);

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
  /// FluteStorage.delete('myName');
  /// ```
  Future<void> delete(String key) async => await _box.delete(key);

  /// Writes a value to the storage with a key if the key's value is null.
  ///
  /// Usage
  ///
  /// ```dart
  /// FluteStorage.deleteKeys(['myName', 'flute']);
  /// ```
  Future<void> deleteAll(List<String> keys) async => await _box.deleteAll(keys);

  /// Deletes all keys and values from the storage, the file
  /// will still stay at its location.
  Future<void> clear() async => await _box.clear();

  /// Closes the storage.
  Future<void> dispose() async {
    await _box.close();
    await Hive.close();
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
