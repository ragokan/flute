import 'package:flute/flute.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FluteLazyStorage<T> {
  final LazyBox _box;
  FluteLazyStorage(this._box);

  static Future<FluteLazyStorage<T>> openBox<T>(String boxName) async {
    final _box = await Hive.openLazyBox(boxName);
    return FluteLazyStorage<T>(_box);
  }

  VoidFunction listen(
    String key,
    void Function(T? value) callback, {
    bool callImmediately = true,
  }) {
    final _stream = _box.watch(key: key).listen((e) => callback(e.value));

    if (callImmediately) {
      read(key).then(callback);
    }

    return _stream.cancel;
  }

  bool contains(String key) => _box.containsKey(key);

  Future<T?> read(String key) async => await _box.get(key);

  Future<void> write(String key, T value) async => await _box.put(key, value);

  Future<void> writeAll(Map<String, T> data) async => await _box.putAll(data);

  Future<void> add(T data) async => await _box.add(data);

  Future<void> addAll(List<T> data) async => await _box.addAll(data);

  Future<void> removeKey(String key) async => await _box.delete(key);

  Future<void> removeKeys(List<String> keys) async =>
      await _box.deleteAll(keys);

  Future<void> clearStorage() async => await _box.clear();

  Future<void> close() async => await _box.close();
}
