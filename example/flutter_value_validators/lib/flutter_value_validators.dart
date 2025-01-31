/// A form validation library for Flutter applications.
///
/// This library provides a comprehensive set of tools for handling form validation
/// in Flutter applications. It includes validators for different data types,
/// validation-aware form widgets, and utilities for managing validation state.
///
/// See also:
/// * [ValidatedForm], for form-level validation management
/// * [ValidatableField], for the base class of validation-aware input fields
/// * [Validator], for the core validation interface

library flutter_value_validators;

export 'src/validators/validation_error.dart';
export 'src/validators/validation_result.dart';
export 'src/validators/number_validator.dart';
export 'src/widgets/validatable_field.dart';
export 'src/widgets/validated_number_field.dart';
export 'src/validators/validator.dart';
export 'src/validators/string_validator.dart';
export 'src/widgets/validated_text_field.dart';
export 'src/widgets/validated_form.dart';