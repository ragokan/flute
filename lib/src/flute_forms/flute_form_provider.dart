import 'package:flute/flute.dart';

class FluteFormProvider extends FluteProviderBase {
  final List<FluteFormModel> _fields = [];

  final Map<String, Object?> _values = {};

  Map<String, Object?> get values => _values;

  bool validate() {
    notifyListeners();
    return _fields.every((element) => element.isValid);
  }

  T readValue<T extends Object?>(String name) => _values[name] as T;

  bool areEqual(String first, String second) =>
      _values[first] == _values[second];

  void add(FluteFormModel field) {
    _fields.add(field);
    _values[field.name] = null;
  }

  void remove(FluteFormModel field) {
    _fields.remove(field);
    _values.remove(field.name);
  }

  void setFieldValue<T extends Object?>(String key, T? value) {
    _values[key] = value;
  }
}
