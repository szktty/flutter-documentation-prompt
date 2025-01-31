import '../../flutter_value_validators.dart';

/// A base class for implementing value validators.
///
/// Validators provide a standardized way to validate input values and produce
/// [ValidationResult]s. They can be chained together using the [custom] method
/// to create complex validation rules.
///
/// See also:
/// * [StringValidator], for validating string inputs
/// * [NumberValidator], for validating numeric inputs
abstract class Validator<T> {
  /// Validates the given value and returns a [ValidationResult].
  ///
  /// If the value is null, implementations should handle this case appropriately.
  ValidationResult<T> validate(T? value);

  /// Creates a new validator that combines this validator with a custom validation function.
  ///
  /// The custom validation is only performed if this validator's validation succeeds.
  /// If this validator fails, the custom validation is skipped.
  Validator<T> custom(ValidationResult<T> Function(T value) validator) {
    return _CustomValidator(this, validator);
  }
}

/// An internal validator that combines a base validator with a custom validation function.
class _CustomValidator<T> extends Validator<T> {
  _CustomValidator(this._baseValidator, this._customValidation);

  final Validator<T> _baseValidator;
  final ValidationResult<T> Function(T value) _customValidation;

  @override
  ValidationResult<T> validate(T? value) {
    final baseResult = _baseValidator.validate(value);
    if (baseResult.isFailure) {
      return baseResult;
    }
    return _customValidation(baseResult.value as T);
  }
}