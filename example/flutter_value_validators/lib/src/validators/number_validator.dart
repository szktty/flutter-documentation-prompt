import 'package:flutter_value_validators/src/validators/validation_error.dart';
import 'package:flutter_value_validators/src/validators/validation_result.dart';
import 'package:flutter_value_validators/src/validators/validator.dart';

/// A validator for numeric values with range and type constraints.
///
/// This validator supports common numeric validation scenarios including range checks
/// and integer validation. Multiple validation rules can be chained together using
/// a fluent interface.
///
/// See also:
/// * [Validator], for the base validation interface
/// * [ValidationResult], for handling validation outcomes
class NumberValidator extends Validator<num> {
  /// Creates a number validator with the specified validation rules.
  NumberValidator({
    this.isRequired = false,
    this.min,
    this.max,
    this.isInteger = false,
  });

  /// Whether a value is required.
  final bool isRequired;

  /// The minimum allowed value.
  final num? min;

  /// The maximum allowed value.
  final num? max;

  /// Whether the value must be an integer.
  final bool isInteger;

  /// Makes this validator require a non-null value.
  NumberValidator required() => copyWith(isRequired: true);
  
  /// Makes this validator require the value to be an integer.
  NumberValidator integer() => copyWith(isInteger: true);
  
  /// Sets the minimum allowed value.
  NumberValidator minimum(num value) => copyWith(min: value);
  
  /// Sets the maximum allowed value.
  NumberValidator maximum(num value) => copyWith(max: value);

  @override
  ValidationResult<num> validate(num? value) {
    if (value == null) {
      if (isRequired) {
        return ValidationResult.failure(
          ValidationError(
            code: 'required',
            message: 'Value is required',
          ),
        );
      }
      return ValidationResult.success(0);  // デフォルト値として0を返す
    }

    if (isInteger && value != value.truncate()) {
      return ValidationResult.failure(
        ValidationError(
          code: 'not_integer',
          message: 'Value must be an integer',
        ),
      );
    }

    if (min != null && value < min!) {
      return ValidationResult.failure(
        ValidationError(
          code: 'less_than_minimum',
          message: 'Value must be greater than or equal to $min',
        ),
      );
    }

    if (max != null && value > max!) {
      return ValidationResult.failure(
        ValidationError(
          code: 'greater_than_maximum',
          message: 'Value must be less than or equal to $max',
        ),
      );
    }

    return ValidationResult.success(value);
  }

  /// Creates a copy of this validator with some fields replaced.
  NumberValidator copyWith({
    bool? isRequired,
    num? min,
    num? max,
    bool? isInteger,
  }) {
    return NumberValidator(
      isRequired: isRequired ?? this.isRequired,
      min: min ?? this.min,
      max: max ?? this.max,
      isInteger: isInteger ?? this.isInteger,
    );
  }
}