import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

class FluteTextField extends FluteFormField {
  FluteTextField({
    Key? key,
    required String name,
  }) : super(key: key, name: name);

  @override
  _FluteTextFieldState createState() => _FluteTextFieldState();
}

class _FluteTextFieldState extends State<FluteTextField> {
  late final TextEditingController _textEditingController;

  FluteFormProvider get _provider => FluteFormProvider.of(context);

  void _listener() {
    // firstly validate
    _provider.setFieldValue(widget.model.name, _textEditingController.text);
  }

  @override
  void initState() {
    super.initState();
    widget.onCreate(context);
    _textEditingController = TextEditingController();
    _provider.addListener(_listener);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    widget.onDispose(context);
    _provider.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
    );
  }
}
