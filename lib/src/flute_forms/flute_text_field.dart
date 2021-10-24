import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

class FluteTextField extends FluteFormField {
  final String name;

  FluteTextField(
    this.name, {
    Key? key,
  }) : super(key: ValueKey(name));

  @override
  _FluteTextFieldState createState() => _FluteTextFieldState();
}

class _FluteTextFieldState extends State<FluteTextField> {
  late final TextEditingController _textEditingController;
  late final FluteFormModel model;

  String? errorText;
  void setErrorText([String? text]) => setState(() => errorText = text);

  FluteFormProvider get _provider => FluteFormProvider.of(context);

  void _listener() {
    model.isValid = false;
    _provider.setFieldValue(model.name, _textEditingController.text);
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    model = FluteFormModel(name: widget.name, field: widget);
    FluteFormProvider.of(context).add(model);
    _provider.addListener(_listener);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    FluteFormProvider.of(context).remove(model);
    _provider.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      decoration: InputDecoration(
        errorText: errorText,
      ),
    );
  }
}
