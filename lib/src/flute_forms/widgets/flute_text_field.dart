import 'package:flute/src/flute_utilities/flute_custom_stream.dart';
import 'package:flutter/material.dart';

import 'package:flute/flute.dart';
import 'package:flutter/services.dart';

class FluteTextField<T extends Object> extends FluteFormField {
  final String name;
  final List<FluteValidator<T>> validators;
  final bool validateOnChange;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String? label;
  final String? helperText;
  final String? suffixText;
  final String? hintText;
  final String? prefixText;
  final bool? obscureText;
  final int? maxLines;
  final int? minLines;

  const FluteTextField(
    this.name, {
    Key? key,
    this.validators = const [],
    this.validateOnChange = true,
    this.textInputAction,
    this.textInputType,
    this.label,
    this.helperText,
    this.suffixText,
    this.hintText,
    this.prefixText,
    this.obscureText,
    this.maxLines,
    this.minLines,
  }) : super(key: key);

  @override
  _FluteTextFieldState<T> createState() => _FluteTextFieldState<T>();
}

class _FluteTextFieldState<T extends Object> extends State<FluteTextField<T>> {
  late final _TextEditingController _textEditingController;
  late final FluteFormModel model;

  String? errorText;
  void setErrorText([String? text]) => setState(() => errorText = text);

  FluteFormProvider get _provider => FluteFormProvider.of(context);

  bool _validate() {
    final _value = () {
      final _text = _textEditingController.text;
      if (T is num) {
        return _text.toNumber();
      }
      return _text;
    }();

    var _result = true;
    for (var validator in widget.validators) {
      if (!validator.validate(_value as T)) {
        setState(() {
          model.isValid = false;
          errorText = validator.errorMessage;
          _result = false;
        });
        break;
      }
    }
    if (_result && model.isValid != _result) {
      setState(() {
        model.isValid = true;
        errorText = null;
      });
    }
    if (_result) {
      _provider.setFieldValue(model.name, _value);
    }
    return _result;
  }

  void _listener() {
    if (!_validate()) {
      if (widget.validateOnChange) {
        _textEditingController.stream.listenIfHasNoListeners((_) {
          _validate();
        });
      }
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController = _TextEditingController();
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
      obscureText: widget.obscureText ?? false,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      controller: _textEditingController,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      inputFormatters:
          T == num ? [FilteringTextInputFormatter.digitsOnly] : null,
      keyboardType:
          widget.textInputType ?? (T == num ? TextInputType.number : null),
      decoration: InputDecoration(
        errorText: errorText,
        hintText: widget.hintText,
        labelText: widget.label,
        helperText: widget.helperText,
        suffixText: widget.suffixText,
        prefixText: widget.prefixText,
      ),
    );
  }
}

class _TextEditingController extends TextEditingController {
  final FluteCustomStream stream = FluteCustomStream();

  @override
  set value(TextEditingValue newValue) {
    if (value != newValue) {
      stream.notifyListeners(null);
    }
    super.value = newValue;
  }

  @override
  void dispose() {
    stream.dispose();
    super.dispose();
  }
}
