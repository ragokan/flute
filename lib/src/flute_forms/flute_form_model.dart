import 'package:flute/flute.dart';

class FluteFormModel {
  final String name;
  final FluteFormField field;
  bool isValid = false;

  FluteFormModel({
    required this.name,
    required this.field,
  });
}
