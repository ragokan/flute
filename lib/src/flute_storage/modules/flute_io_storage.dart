import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// The FluteStorage implementation for io.
class ImplFluteStorage {
  Map<String, dynamic> get _emptyData => {};

  Map<String, dynamic> _currentData = {};
  String get _encodedData => jsonEncode(_currentData);

  /// The file that we are writing all the data.
  /// Whenever we import storage, the file is created automatically
  /// if the file doesn't exists.
  late final File _file;

  /// Inıtializes the io version of storage, it is async because of
  /// the path library, an amazingly simple library that gives us
  /// documents directory of app.
  Future<void> init({required String storageName}) async {
    final appDocDirectory = await getApplicationDocumentsDirectory();
    final path = appDocDirectory.path;
    final slash = Platform.isWindows ? '\\' : '/';
    final dir = '$path$slash$storageName.fluteStorage';
    _file = File(dir);
    if (!_file.existsSync()) {
      File(dir).createSync(recursive: true);
    }
    _currentData = _getData();
  }

  Map<String, dynamic> _getData() {
    try {
      final stringData = _file.readAsStringSync();
      return stringData.trim() == ''
          ? _emptyData
          : jsonDecode(stringData) ?? _emptyData;
    } on FormatException catch (error) {
      clearStorage();
      debugPrint('An error happened in FluteStorage\n Error: ${error.message}');
      return _emptyData;
    }
  }

  void _saveToIOStorage() => _file.writeAsStringSync(_encodedData);

  /// Get data from local storage.
  T? read<T>(String key) => _currentData[key];

  /// Writes current data to the local storage.
  void write<T>(String key, T value) {
    _currentData[key] = value;
    return _saveToIOStorage();
  }

  /// Writes multiple data to the local storage.
  void writeMulti(Map<String, dynamic> data) {
    data.forEach((key, value) => _currentData[key] = value);
    return _saveToIOStorage();
  }

  /// Deletes a key from the storage.
  void removeKey(String key) {
    _currentData.remove(key);
    return _saveToIOStorage();
  }

  /// Deletes a key from the storage.
  void removeKeys(List<String> keys) {
    keys.forEach((key) => _currentData.remove(key));
    return _saveToIOStorage();
  }

  /// Clear the data of local storage.
  void clearStorage() {
    _currentData = _emptyData;
    return _saveToIOStorage();
  }

  /// Delete the storage permanently.
  void deleteStorage() => _file.delete();
}
