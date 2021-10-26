import 'package:flute/flute.dart';

abstract class NumberValidators extends FluteValidator<num?> {
  NumberValidators(String errorMessage) : super(errorMessage);

  static _RequiredValidator required(String errorMessage) =>
      _RequiredValidator(errorMessage);

  static _MinValidator min(String errorMessage, {required int min}) =>
      _MinValidator(errorMessage, min);

  static _MaxValidator max(String errorMessage, {required int max}) =>
      _MaxValidator(errorMessage, max);

  static _EqualValidator equal(String errorMessage, {required int value}) =>
      _EqualValidator(errorMessage, value);
}

class _RequiredValidator extends NumberValidators {
  _RequiredValidator(String errorMessage) : super(errorMessage);

  @override
  bool validate(value) => value != null;
}

class _MinValidator extends NumberValidators {
  final int length;
  _MinValidator(String errorMessage, this.length) : super(errorMessage);

  @override
  bool validate(value) {
    if (value == null) return false;
    return value > length;
  }
}

class _MaxValidator extends NumberValidators {
  final int length;
  _MaxValidator(String errorMessage, this.length) : super(errorMessage);

  @override
  bool validate(value) {
    if (value == null) return false;
    return value < length;
  }
}

class _EqualValidator extends NumberValidators {
  final int other;
  _EqualValidator(String errorMessage, this.other) : super(errorMessage);

  @override
  bool validate(value) {
    if (value == null) return false;
    return value == other;
  }
}
