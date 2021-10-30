import 'package:flute/flute.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef _FromMap<T> = T Function(Map<String, Object> e);
typedef _ToMap<T> = Map<String, Object> Function(T e);

class FluteTypedStorage<T> {
  final Box _box;
  FluteTypedStorage(this._box, this.toMap, this.fromMap);

  final _ToMap<T> toMap;
  final _FromMap<T> fromMap;

  static Future<FluteTypedStorage<T>> openBox<T>(
    String boxName, {
    required _ToMap<T> toMap,
    required _FromMap<T> fromMap,
  }) async {
    final _box = await Hive.openBox(boxName);
    return FluteTypedStorage<T>(_box, toMap, fromMap);
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

  T? read(String key) {
    final _value = _box.get(key);
    if (_value != null) {
      return fromMap(_value);
    }
  }

  void removeWhere(bool test(T element)) {
    for (var entry in _box.toMap().entries) {
      if (test(fromMap(entry.value))) {
        _box.delete(entry);
      }
    }
  }

  Future<void> add(T data) async => await _box.add(toMap(data));

  Future<void> addAll(List<T> data) async => await _box.addAll(data.map(toMap));

  List<T> get values =>
      _box.values.map<T>(fromMap as T Function(dynamic)).toList().cast<T>();

  List<T> paginatedValues({
    int? startKey,
    int? endKey,
  }) =>
      _box
          .valuesBetween(startKey: startKey, endKey: endKey)
          .map<T>(fromMap as T Function(dynamic))
          .toList()
          .cast<T>();

  Future<void> removeAt(int index) async => await _box.deleteAt(index);

  Future<void> removeKeys(List<int> keys) async => await _box.deleteAll(keys);

  Future<void> clearStorage() async => await _box.clear();

  Future<void> close() async => await _box.close();
}
