import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// The FluteStorage implementation for io.
class ImplFluteStorage {
  bool _isInitialized = false;

  final Map<String, dynamic> _emptyData = {};

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
    File(dir).createSync(recursive: true);
    _file = File(dir);
    _currentData = _getData();
    _isInitialized = true;
  }

  Map<String, dynamic> _getData() {
    try {
      var stringData = _file.readAsStringSync();
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
  T? read<T>(String key) => _isInitialized ? _currentData[key] : null;

  /// Writes current data to the local storage.
  void write<T>(String key, T value) {
    if (!_isInitialized) {
      return debugPrint('You have to init FluteStorage to use it.');
    }
    _currentData[key] = value;
    _saveToIOStorage();
  }

  /// Writes multiple data to the local storage.
  void writeMulti(Map<String, dynamic> data) {
    if (!_isInitialized) return;
    data.forEach((key, value) => _currentData[key] = value);
    _saveToIOStorage();
  }

  /// Deletes a key from the storage.
  void removeKey(String key) {
    if (!_isInitialized) return;
    _currentData.remove(key);
    _saveToIOStorage();
  }

  /// Deletes a key from the storage.
  void removeKeys(List<String> keys) {
    if (!_isInitialized) return;
    keys.forEach((key) => _currentData.remove(key));
    _saveToIOStorage();
  }

  /// Clear the data of local storage.
  void clearStorage() {
    if (!_isInitialized) return;

    _file.writeAsStringSync(jsonEncode(_emptyData));
  }

  /// Delete the storage permanently.
  void deleteStorage() {
    if (!_isInitialized) return;
    _file.deleteSync();
  }
}
