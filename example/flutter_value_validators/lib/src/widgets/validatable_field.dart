import '../validators/validation_error.dart';

/// An interface that represents a form field that can be validated.
///
/// This interface allows form fields to be validated and tracked by the parent form,
/// while keeping the implementation details of each field private.
abstract interface class ValidatableField {
  /// Validates the field and returns true if the field is valid.
  bool validate();

  /// The current validation error, if any.
  ValidationError? get error;
}