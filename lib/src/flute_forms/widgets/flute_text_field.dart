import 'package:flute/src/flute_utilities/flute_custom_stream.dart';
import 'package:flutter/material.dart';

import 'package:flute/flute.dart';

class FluteTextField<T extends Object> extends FluteFormField {
  final String name;
  final List<FluteValidator<T>> validators;
  final bool validateOnChange;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;

  const FluteTextField(
    this.name, {
    Key? key,
    this.validators = const [],
    this.validateOnChange = true,
    this.textInputAction,
    this.textInputType,
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
        _textEditingController.stream.listenSingle((_) {
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
      controller: _textEditingController,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      keyboardType:
          widget.textInputType ?? (T == num ? TextInputType.number : null),
      decoration: InputDecoration(
        errorText: errorText,
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
