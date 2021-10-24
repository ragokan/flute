import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

class FluteTextField<T extends Object> extends FluteFormField {
  final String name;
  final List<FluteValidator<T>> validators;
  final bool validateOnChange;
  final TextInputAction? textInputAction;

  const FluteTextField(
    this.name, {
    Key? key,
    this.validators = const [],
    this.validateOnChange = true,
    this.textInputAction,
  }) : super(key: key);

  @override
  _FluteTextFieldState<T> createState() => _FluteTextFieldState<T>();
}

class _FluteTextFieldState<T extends Object> extends State<FluteTextField> {
  late final TextEditingController _textEditingController;
  late final FluteFormModel model;

  String? errorText;
  void setErrorText([String? text]) => setState(() => errorText = text);

  FluteFormProvider get _provider => FluteFormProvider.of(context);

  bool _validate(Object value) {
    var _result = true;
    for (var validator in widget.validators) {
      if (!validator.validate(value)) {
        setState(() {
          model.isValid = false;
          errorText = validator.errorMessage;
          _result = false;
        });
        break;
      }
    }
    return _result;
  }

  void _listener() {
    final _value = () {
      final _text = _textEditingController.text;
      if (T is num) {
        return _text.toNumber();
      }
      return _text;
    }();

    final _isValid = _validate(_value);
    if (!_isValid) {
      // ignore: invalid_use_of_protected_member
      if (widget.validateOnChange && !_textEditingController.hasListeners) {
        _textEditingController.addListener(() => _validate(_value));
      }
      return;
    }

    _provider.setFieldValue(model.name, _value);
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
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        errorText: errorText,
      ),
    );
  }
}
