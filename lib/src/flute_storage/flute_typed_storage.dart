import 'package:flute/flute.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FluteTypedStorage<T> {
  final Box _box;
  FluteTypedStorage(this._box);

  static Future<FluteTypedStorage<T>> openBox<T>(String boxName) async {
    final _box = await Hive.openBox(boxName);
    return FluteTypedStorage<T>(_box);
  }

  VoidFunction listen(
    String key,
    void Function(T? value) callback, {
    bool callImmediately = true,
  }) {
    final _stream = _box.watch(key: key).listen((e) => callback(e.value));

    if (callImmediately) {
      callback(read(key));
    }

    return _stream.cancel;
  }

  bool contains(String key) => _box.containsKey(key);

  T? read(String key) => _box.get(key);

  Future<void> write(String key, T value) async => await _box.put(key, value);

  Future<void> writeAll(Map<String, T> data) async => await _box.putAll(data);

  Future<void> add(T data) async => await _box.add(data);

  Future<void> addAll(List<T> data) async => await _box.addAll(data);

  List<T> get values => _box.values.toList().cast<T>();

  List<dynamic> get keys => _box.keys.toList();

  List<T> paginatedValues({
    int? startKey,
    int? endKey,
  }) =>
      _box.valuesBetween(startKey: startKey, endKey: endKey).toList().cast<T>();

  Future<void> removeKey(String key) async => await _box.delete(key);

  Future<void> removeKeys(List<String> keys) async =>
      await _box.deleteAll(keys);

  Future<void> clearStorage() async => await _box.clear();

  Future<void> close() async => await _box.close();
}
