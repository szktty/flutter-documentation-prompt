/// A class that represents a validation error.
///
/// This class includes both a machine-readable error code and a human-readable
/// error message. The error code can be used for programmatic error handling,
/// while the message can be displayed to users.
///
/// See also:
/// * [ValidationResult], which uses this class to represent validation failures
class ValidationError {
  /// Creates a validation error with the specified code and message.
  const ValidationError({
    required this.code,
    required this.message,
  });

  /// A machine-readable code identifying the type of validation error.
  final String code;

  /// A human-readable message describing the validation error.
  final String message;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationError &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message;

  @override
  int get hashCode => Object.hash(code, message);

  @override
  String toString() => 'ValidationError(code: $code, message: $message)';
}
