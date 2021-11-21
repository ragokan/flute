import 'package:hive_flutter/hive_flutter.dart';

typedef _FromMap<T> = T Function(Map<String, dynamic> e);
typedef _ToMap<T> = Map<String, dynamic> Function(T e);

class TypedConverter<T> {
  final _ToMap<T> toMap;
  final _FromMap<T> fromMap;

  TypedConverter({required this.toMap, required this.fromMap});
}

class TypedBox<T> {
  Box _box;
  final TypedConverter<T> _typedConverter;
  TypedBox(String boxName, this._typedConverter) : _box = Hive.box(boxName);

  static Future<TypedBox<T>> openBox<T>(
    String boxName, {
    required TypedConverter<T> converter,
  }) async {
    await Hive.openBox(boxName);
    return TypedBox<T>(boxName, converter);
  }

  Future<void> deleteWhere(bool test(T element)) async {
    final _keys = <int>[];
    for (var entry in _box.toMap().entries) {
      if (test(_typedConverter.fromMap(entry.value))) {
        _keys.add(entry.key);
      }
    }
    await _box.deleteAll(_keys);
  }

  List<T> where(bool test(T element)) {
    final _entries = <T>[];
    for (var entry in _box.values) {
      final _generated = _typedConverter.fromMap(entry);
      if (test(_generated)) {
        _entries.add(_generated);
      }
    }
    return _entries;
  }

  Future<int> add(T data) async => await _box.add(_typedConverter.toMap(data));

  Future<void> addAll(List<T> data) async =>
      await _box.addAll(data.map(_typedConverter.toMap));

  List<T> getValues() => _box.values
      .map<T>((v) => _typedConverter.fromMap(Map<String, dynamic>.from(v)))
      .toList()
      .cast<T>();

  List<T> paginatedValues({
    int? startKey,
    int? endKey,
  }) =>
      _box
          .valuesBetween(startKey: startKey, endKey: endKey)
          .map<T>((v) => _typedConverter.fromMap(Map<String, dynamic>.from(v)))
          .toList()
          .cast<T>();

  Future<void> deleteAt(int index) async => await _box.deleteAt(index);

  bool get isNotEmpty => _box.keys.isNotEmpty;

  Future<void> clear() async => await _box.clear();

  Future<void> open() async => _box = await Hive.openBox(_box.name);

  Future<void> close() async => await _box.close();
}