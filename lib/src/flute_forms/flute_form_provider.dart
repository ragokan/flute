import 'package:flute/flute.dart';
import 'package:flutter/material.dart';

class FluteFormProvider extends FluteProviderBase {
  final List<FluteFormField> _fields = [];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  void hoppala() {}

  late final FocusScopeNode focusNode;

  void add(FluteFormField field) => _fields.add(field);
  void remove(FluteFormField field) => _fields.remove(field);

  static FluteFormProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<FluteFormProvider>(context, listen: listen);
}
