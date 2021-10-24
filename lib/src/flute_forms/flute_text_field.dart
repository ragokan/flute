import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

class FluteTextField extends FluteFormField {
  const FluteTextField({
    Key? key,
    required this.name,
  }) : super(key: key, name: name);

  @override
  final String name;

  @override
  _FluteTextFieldState createState() => _FluteTextFieldState();
}

class _FluteTextFieldState extends State<FluteTextField> {
  @override
  void initState() {
    super.initState();
    widget.onCreate(context);
  }

  @override
  void dispose() {
    widget.onDispose(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}
