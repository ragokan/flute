import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

typedef _FromMap<T> = T Function(Map<String, Object> e);
typedef _ToMap<T> = Map<String, dynamic> Function(T e);

class TypedConverter<T> {
  final _ToMap<T> toMap;
  final _FromMap<T> fromMap;

  TypedConverter({required this.toMap, required this.fromMap});
}

class TypedStorage<T> {
  final Box _box;
  final TypedConverter _typedConverter;
  TypedStorage(this._box, this._typedConverter);

  static Future<TypedStorage<T>> openBox<T>(
    String boxName, {
    required TypedConverter converter,
  }) async {
    final _box = await Hive.openBox(boxName);
    return TypedStorage<T>(_box, converter);
  }

  void removeWhere(bool test(T element)) {
    for (var entry in _box.toMap().entries) {
      if (test(_typedConverter.fromMap(entry.value))) {
        _box.delete(entry);
      }
    }
  }

  List<T> where(bool test(T element)) {
    final _entries = <T>[];
    for (var entry in _box.values) {
      if (test(_typedConverter.fromMap(entry))) {
        _entries.add(entry);
      }
    }
    return _entries;
  }

  void forEach(void action(T element)) =>
      _box.values.forEach(action as void Function(dynamic));

  T? firstWhereOrNull(bool test(T element)) =>
      _box.values.firstWhereOrNull(test as bool Function(dynamic));

  Future<void> add(T data) async => await _box.add(_typedConverter.toMap(data));

  Future<void> addAll(List<T> data) async =>
      await _box.addAll(data.map(_typedConverter.toMap));

  List<T> get values => _box.values
      .map<T>(_typedConverter.fromMap as T Function(dynamic))
      .toList()
      .cast<T>();

  List<T> paginatedValues({
    int? startKey,
    int? endKey,
  }) =>
      _box
          .valuesBetween(startKey: startKey, endKey: endKey)
          .map<T>(_typedConverter.fromMap as T Function(dynamic))
          .toList()
          .cast<T>();

  Future<void> removeAt(int index) async => await _box.deleteAt(index);

  Future<void> clearStorage() async => await _box.clear();

  Future<void> close() async => await _box.close();
}
