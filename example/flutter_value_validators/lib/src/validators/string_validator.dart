import '../../flutter_value_validators.dart';

/// A validator for string values with various validation rules.
///
/// This validator supports common string validation scenarios including length checks,
/// pattern matching, and email format validation. Multiple validation rules can be
/// chained together using a fluent interface.
///
/// See also:
/// * [Validator], for the base validation interface
/// * [ValidationResult], for handling validation outcomes
class StringValidator extends Validator<String> {
  /// Creates a string validator with the specified validation rules.
  StringValidator({
    this.isRequired = false,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.isEmail = false,
  });

  /// Whether the string value is required.
  final bool isRequired;

  /// The minimum allowed length of the string.
  final int? minLength;

  /// The maximum allowed length of the string.
  final int? maxLength;

  /// A pattern that the string must match.
  final RegExp? pattern;

  /// Whether the string must be in email format.
  final bool isEmail;

  /// A regular expression that matches email addresses.
  static final _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  /// Makes this validator require a non-empty value.
  StringValidator required() => copyWith(isRequired: true);
  
  /// Makes this validator require the value to be in email format.
  StringValidator email() => copyWith(isEmail: true);
  
  /// Sets the minimum allowed length for the string.
  StringValidator min(int length) => copyWith(minLength: length);
  
  /// Sets the maximum allowed length for the string.
  StringValidator max(int length) => copyWith(maxLength: length);
  
  /// Sets a pattern that the string must match.
  StringValidator matches(RegExp regex) => copyWith(pattern: regex);

  @override
  ValidationResult<String> validate(String? value) {
    if (value == null || value.isEmpty) {
      if (isRequired) {
        return ValidationResult.failure(
          ValidationError(
            code: 'required',
            message: 'Value is required',
          ),
        );
      }
      return ValidationResult.success(value ?? '');
    }

    if (minLength != null && value.length < minLength!) {
      return ValidationResult.failure(
        ValidationError(
          code: 'min_length',
          message: 'Minimum length is $minLength',
        ),
      );
    }

    if (maxLength != null && value.length > maxLength!) {
      return ValidationResult.failure(
        ValidationError(
          code: 'max_length',
          message: 'Maximum length is $maxLength',
        ),
      );
    }

    if (isEmail && !_emailRegExp.hasMatch(value)) {
      return ValidationResult.failure(
        ValidationError(
          code: 'invalid_email',
          message: 'Invalid email format',
        ),
      );
    }

    if (pattern != null && !pattern!.hasMatch(value)) {
      return ValidationResult.failure(
        ValidationError(
          code: 'pattern_mismatch',
          message: 'Value does not match the required pattern',
        ),
      );
    }

    return ValidationResult.success(value);
  }

  /// Creates a copy of this validator with some fields replaced.
  StringValidator copyWith({
    bool? isRequired,
    int? minLength,
    int? maxLength,
    RegExp? pattern,
    bool? isEmail,
  }) {
    return StringValidator(
      isRequired: isRequired ?? this.isRequired,
      minLength: minLength ?? this.minLength,
      maxLength: maxLength ?? this.maxLength,
      pattern: pattern ?? this.pattern,
      isEmail: isEmail ?? this.isEmail,
    );
  }
}
