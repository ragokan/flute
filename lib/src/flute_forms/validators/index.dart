export './string_validators.dart';
export './num_validators.dart';

abstract class FluteValidator<T> {
  final String errorMessage;

  FluteValidator(this.errorMessage);

  bool validate(T value);
}
