import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

abstract class FluteFormField extends StatefulWidget {
  final String name;

  void onCreate(BuildContext context) {
    FluteFormProvider.of(context).add(this);
  }

  const FluteFormField({
    Key? key,
    required this.name,
  }) : super(key: key);
}

class FormWidget extends FluteFormField {
  @override
  final String name;

  const FormWidget(
    this.name, {
    Key? key,
  }) : super(
          key: key,
          name: name,
        );

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  @override
  void initState() {
    super.initState();
    widget.onCreate(context);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}
