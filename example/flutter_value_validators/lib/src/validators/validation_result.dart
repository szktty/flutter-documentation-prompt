import 'package:flutter_value_validators/src/validators/validation_error.dart';

/// A class that represents the result of a validation operation.
///
/// A validation result can either be successful, containing a valid value,
/// or a failure, containing a [ValidationError]. The [fold] method provides
/// a type-safe way to handle both cases.
///
/// See also:
/// * [ValidationError], which describes validation failures
/// * [Validator], which produces validation results
class ValidationResult<T> {
  /// Creates a successful validation result containing the validated value.
  const ValidationResult.success(this.value) : error = null;

  /// Creates a failed validation result containing the validation error.
  const ValidationResult.failure(this.error) : value = null;

  /// The validated value if the validation was successful.
  final T? value;

  /// The validation error if the validation failed.
  final ValidationError? error;

  /// Whether this result represents a successful validation.
  bool get isSuccess => error == null;

  /// Whether this result represents a failed validation.
  bool get isFailure => error != null;

  /// Handles both success and failure cases in a type-safe way.
  ///
  /// The appropriate callback is called based on whether the validation
  /// succeeded or failed.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(ValidationError error) onFailure,
  }) {
    return isSuccess ? onSuccess(value as T) : onFailure(error!);
  }
}
