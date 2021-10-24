import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

class FluteFormProvider extends FluteProviderBase {
  final List<FluteFormField> _fields = [];

  late final Map<String, Object?> _values;

  void validate() {
    notifyListeners();
  }

  late final FocusScopeNode focusNode;

  void add(FluteFormField field) {
    _fields.add(field);
    _values[field.model.name] = null;
  }

  void remove(FluteFormField field) {
    _fields.remove(field);
    _values.remove(field.model.name);
  }

  void setFieldValue<T extends Object?>(String key, T? value) {
    _values[key] = value;
  }

  static FluteFormProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<FluteFormProvider>(context, listen: listen);
}
