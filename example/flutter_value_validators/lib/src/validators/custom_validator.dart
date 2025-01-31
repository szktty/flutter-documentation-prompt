import 'package:flutter_value_validators/src/validators/validation_error.dart';
import 'package:flutter_value_validators/src/validators/validation_result.dart';
import 'package:flutter_value_validators/src/validators/validator.dart';

/// A validator that applies a custom validation function.
///
/// This validator allows for the creation of specialized validation rules not
/// covered by the standard validators. It wraps a validation function that takes
/// a value and returns a [ValidationResult].
///
/// See also:
/// * [Validator], for the base validation interface
/// * [ValidationResult], for handling validation outcomes
class CustomValidator<T> extends Validator<T> {
  /// Creates a custom validator with the specified validation function.
  CustomValidator(this._validation);

  final ValidationResult<T> Function(T? value) _validation;

  @override
  ValidationResult<T> validate(T? value) => _validation(value);

  /// Creates a new validator that chains this validator with another validation function.
  ///
  /// The additional validation is only performed if this validator's validation succeeds.
  @override
  Validator<T> custom(ValidationResult<T> Function(T value) validator) {
    return _ChainedValidator(this, validator);
  }
}

/// An internal validator that chains two validators together.
class _ChainedValidator<T> extends Validator<T> {
  _ChainedValidator(this._first, this._second);

  final Validator<T> _first;
  final ValidationResult<T> Function(T value) _second;

  @override
  ValidationResult<T> validate(T? value) {
    final firstResult = _first.validate(value);
    if (firstResult.isFailure) {
      return firstResult;
    }
    return _second(firstResult.value as T);
  }
}

/// Utility functions for creating common custom validators.
extension CustomValidatorExtensions<T> on Validator<T> {
  /// Creates a custom validator that applies an additional validation rule.
  ///
  /// The validation rule is specified as a function that takes a value and
  /// returns a [ValidationResult]. This allows for complex validation logic
  /// beyond what the standard validators provide.
  Validator<T> customRule(
    ValidationResult<T> Function(T value) rule, {
    String code = 'custom_validation',
    String message = 'Validation failed',
  }) {
    return custom((value) {
      try {
        return rule(value);
      } catch (e) {
        return ValidationResult.failure(
          ValidationError(
            code: code,
            message: message,
          ),
        );
      }
    });
  }
}