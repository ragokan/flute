import 'dart:convert';
// For analysis, it gives error, weirdly.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// The FluteStorage implementation for web.
class ImplFluteStorage {
  bool _isInitialized = false;

  final Map<String, dynamic> _emptyData = {};

  Map<String, dynamic> _currentData = {};
  String get _encodedData => jsonEncode(_currentData);

  final String _key = 'fluteStorage';

  html.Storage get _localStorage => html.window.localStorage;

  /// Future for IO version.
  /// Inits the local storage and get current data.
  Future<void> init({required String storageName}) async {
    if (!_localStorage.containsKey(_key)) {
      _localStorage[_key] = jsonEncode(_emptyData);
    }
    _currentData = _getData();
    _isInitialized = true;
  }

  Map<String, dynamic> _getData() {
    try {
      return _localStorage.containsKey(_key)
          ? jsonDecode(_localStorage[_key]!)
          : _emptyData;
    } on FormatException catch (_) {
      clearStorage();
      return _emptyData;
    }
  }

  void _saveToWebStorage() => _localStorage[_key] = _encodedData;

  /// Get data from local storage.
  T? read<T>(String key) => _isInitialized ? _currentData[key] : null;

  /// Writes current data to the local storage.
  void write<T>(String key, T value) {
    if (!_isInitialized) return;
    _currentData[key] = value;
    _saveToWebStorage();
  }

  /// Writes multiple data to the local storage.
  void writeMulti(Map<String, dynamic> data) {
    if (!_isInitialized) return;
    data.forEach((key, value) => _currentData[key] = value);
    _saveToWebStorage();
  }

  /// Deletes a key from the storage.
  void removeKey(String key) {
    if (!_isInitialized) return;
    _currentData.remove(key);
    _saveToWebStorage();
  }

  /// Deletes a key from the storage.
  void removeKeys(List<String> keys) {
    if (!_isInitialized) return;
    keys.forEach((key) => _currentData.remove(key));
    _saveToWebStorage();
  }

  /// Clear the data of local storage.
  void clearStorage() {
    if (!_isInitialized) return;

    _localStorage[_key] = jsonEncode(_emptyData);
  }

  /// Delete the storage permanently.
  void deleteStorage() {
    if (!_isInitialized) return;
    _localStorage.remove(_key);
  }
}
