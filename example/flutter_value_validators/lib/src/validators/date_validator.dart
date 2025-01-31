import 'package:flutter_value_validators/src/validators/validation_error.dart';
import 'package:flutter_value_validators/src/validators/validation_result.dart';
import 'package:flutter_value_validators/src/validators/validator.dart';

/// A validator for date values with range constraints.
///
/// This validator supports common date validation scenarios including range checks
/// and required field validation. Multiple validation rules can be chained together
/// using a fluent interface.
///
/// See also:
/// * [Validator], for the base validation interface
/// * [ValidationResult], for handling validation outcomes
class DateValidator extends Validator<DateTime> {
  /// Creates a date validator with the specified validation rules.
  DateValidator({
    this.isRequired = false,
    this.minDate,
    this.maxDate,
  });

  /// Whether a value is required.
  final bool isRequired;

  /// The minimum allowed date.
  final DateTime? minDate;

  /// The maximum allowed date.
  final DateTime? maxDate;

  /// Makes this validator require a non-null value.
  DateValidator required() => copyWith(isRequired: true);

  /// Sets the minimum allowed date.
  DateValidator after(DateTime date) => copyWith(minDate: date);

  /// Sets the maximum allowed date.
  DateValidator before(DateTime date) => copyWith(maxDate: date);

  @override
  ValidationResult<DateTime> validate(DateTime? value) {
    if (value == null) {
      if (isRequired) {
        return ValidationResult.failure(
          ValidationError(
            code: 'required',
            message: 'Date is required',
          ),
        );
      }
      return ValidationResult.success(DateTime.now());
    }

    if (minDate != null && value.isBefore(minDate!)) {
      return ValidationResult.failure(
        ValidationError(
          code: 'date_before_minimum',
          message: 'Date must be after ${minDate!.toIso8601String()}',
        ),
      );
    }

    if (maxDate != null && value.isAfter(maxDate!)) {
      return ValidationResult.failure(
        ValidationError(
          code: 'date_after_maximum',
          message: 'Date must be before ${maxDate!.toIso8601String()}',
        ),
      );
    }

    return ValidationResult.success(value);
  }

  /// Creates a copy of this validator with some fields replaced.
  DateValidator copyWith({
    bool? isRequired,
    DateTime? minDate,
    DateTime? maxDate,
  }) {
    return DateValidator(
      isRequired: isRequired ?? this.isRequired,
      minDate: minDate ?? this.minDate,
      maxDate: maxDate ?? this.maxDate,
    );
  }
}