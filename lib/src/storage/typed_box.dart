import 'package:flute/flute.dart';
import 'package:flutter/foundation.dart';
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
    try {
      await Hive.openBox(boxName);
      return TypedBox<T>(boxName, converter);
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-openBox',
          error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteWhere(bool test(T element)) async {
    try {
      final _keys = <int>[];
      for (var entry in _box.toMap().entries) {
        if (test(_typedConverter.fromMap(entry.value))) {
          _keys.add(entry.key);
        }
      }
      await _box.deleteAll(_keys);
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-deleteWhere',
          error: error, stackTrace: stackTrace);
    }
  }

  List<T> where(bool test(T element)) {
    try {
      final _entries = <T>[];
      for (var entry in _box.values) {
        final _generated = _typedConverter.fromMap(entry);
        if (test(_generated)) {
          _entries.add(_generated);
        }
      }
      return _entries;
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-where',
          error: error, stackTrace: stackTrace);
      return List.empty();
    }
  }

  Future<int> add(T data) async {
    try {
      return await _box.add(_typedConverter.toMap(data));
    } catch (error, stackTrace) {
      if (!kReleaseMode) {
        rethrow;
      }
      FluteObserver.observer?.onStorageError('typedstorage-add',
          error: error, stackTrace: stackTrace);
      return -1;
    }
  }

  Future<void> addAll(List<T> data) async {
    try {
      await _box.addAll(data.map(_typedConverter.toMap));
    } catch (error, stackTrace) {
      if (!kReleaseMode) {
        rethrow;
      }
      FluteObserver.observer?.onStorageError('typedstorage-addAll',
          error: error, stackTrace: stackTrace);
    }
  }

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

  Future<void> deleteAt(int index) async {
    try {
      await _box.deleteAt(index);
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-deleteAt',
          error: error, stackTrace: stackTrace);
    }
  }

  bool get isNotEmpty => _box.keys.isNotEmpty;

  Future<void> clear() async {
    try {
      await _box.clear();
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-clear',
          error: error, stackTrace: stackTrace);
    }
  }

  Future<void> open() async {
    try {
      _box = await Hive.openBox(_box.name);
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-open',
          error: error, stackTrace: stackTrace);
    }
  }

  Future<void> close() async {
    try {
      await _box.close();
    } catch (error, stackTrace) {
      FluteObserver.observer?.onStorageError('typedstorage-close',
          error: error, stackTrace: stackTrace);
    }
  }
}
