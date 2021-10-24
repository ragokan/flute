import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

class FluteFormProvider extends FluteProviderBase {
  final List<FluteFormField> _fields = [];

  FluteFormProvider() {
    print('Created a form provider');
  }

  void add(FluteFormField field) {
    _fields.add(field);
    print('Added a new field with ${field.name}');
  }

  static FluteFormProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<FluteFormProvider>(context, listen: listen);
}
