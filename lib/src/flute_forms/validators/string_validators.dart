import 'package:flute/flute.dart';

abstract class StringValidators extends FluteValidator<String> {
  StringValidators(String errorMessage) : super(errorMessage);

  static _RequiredValidator required(String errorMessage) =>
      _RequiredValidator(errorMessage);

  static _EmailValidator email(String errorMessage) =>
      _EmailValidator(errorMessage);

  static _MinValidator min(String errorMessage, {required int minLength}) =>
      _MinValidator(errorMessage, minLength);

  static _MaxValidator max(String errorMessage, {required int maxLength}) =>
      _MaxValidator(errorMessage, maxLength);

  static _MatchValidator match(String errorMessage, {required String value}) =>
      _MatchValidator(errorMessage, value);
}

class _EmailValidator extends StringValidators {
  _EmailValidator(String errorMessage) : super(errorMessage);

  final RegExp _emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  @override
  bool validate(value) {
    if (value.isEmpty) return false;
    return _emailRegex.hasMatch(value);
  }
}

class _RequiredValidator extends StringValidators {
  _RequiredValidator(String errorMessage) : super(errorMessage);

  @override
  bool validate(value) => value.isNotEmpty;
}

class _MinValidator extends StringValidators {
  final int length;
  _MinValidator(String errorMessage, this.length) : super(errorMessage);

  @override
  bool validate(value) => value.length > length;
}

class _MaxValidator extends StringValidators {
  final int length;
  _MaxValidator(String errorMessage, this.length) : super(errorMessage);

  @override
  bool validate(value) => value.length < length;
}

class _MatchValidator extends StringValidators {
  final String other;
  _MatchValidator(String errorMessage, this.other) : super(errorMessage);

  @override
  bool validate(value) => value == other;
}
