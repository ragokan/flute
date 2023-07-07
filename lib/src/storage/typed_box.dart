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
  Box? __box;
  Box get _box {
    assert(__box != null, 'You have to open the box to use it!');
    return __box!;
  }

  // For test purposes
  Box get box => __box!;

  final String _boxName;

  final TypedConverter<T> _typedConverter;
  TypedBox(String boxName, this._typedConverter, {bool open = false})
      : _boxName = boxName,
        __box = open ? Hive.box(boxName) : null;

  static Future<TypedBox<T>> openBox<T>(
    String boxName, {
    required TypedConverter<T> converter,
  }) async {
    try {
      await Hive.openBox(boxName);
      return TypedBox<T>(boxName, converter, open: true);
    } catch (_) {
      rethrow;
    }
  }

  Future<void> deleteWhere(bool test(T element)) async {
    try {
      final _keys = <int>[];
      for (var entry in _box.toMap().entries) {
        if (test(
            _typedConverter.fromMap(Map<String, dynamic>.from(entry.value)))) {
          _keys.add(entry.key);
        }
      }
      await _box.deleteAll(_keys);
    } catch (_) {}
  }

  Future<void> updateWhere(bool test(T element), T newElement) async {
    try {
      for (var i = 0; i < _box.values.length; i++) {
        if (test(
          _typedConverter.fromMap(
            Map<String, dynamic>.from(_box.values.elementAt(i)),
          ),
        )) {
          await _box.putAt(i, _typedConverter.toMap(newElement));
        }
      }
    } catch (_) {}
  }

  List<T> where(bool test(T element)) {
    try {
      final _entries = <T>[];
      for (var entry in _box.values) {
        final _generated =
            _typedConverter.fromMap(Map<String, dynamic>.from(entry));
        if (test(_generated)) {
          _entries.add(_generated);
        }
      }
      return _entries;
    } catch (_) {
      return List.empty();
    }
  }

  Future<int> add(T data) async {
    try {
      return await _box.add(_typedConverter.toMap(data));
    } catch (_) {
      if (!kReleaseMode) {
        rethrow;
      }
      return -1;
    }
  }

  Future<void> addAll(List<T> data) async {
    try {
      await _box.addAll(data.map(_typedConverter.toMap));
    } catch (_) {
      if (!kReleaseMode) {
        rethrow;
      }
    }
  }

  List<T> get values => _box.values
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
    } catch (_) {}
  }

  bool get isNotEmpty => _box.keys.isNotEmpty;

  Future<void> clear() async {
    try {
      await _box.clear();
    } catch (_) {}
  }

  Future<void> open() async {
    try {
      __box = await Hive.openBox(_boxName);
    } catch (_) {}
  }

  Future<void> close() async {
    try {
      await _box.close();
    } catch (_) {}
  }
}
