import 'package:flutter/material.dart';

import '../validators/validation_error.dart';
import 'validatable_field.dart';

/// A form widget that manages validation for its child fields.
///
/// This widget coordinates validation across multiple [ValidatableField] widgets,
/// providing form-level validation control and state management. It also supports
/// displaying validation errors through [ValidationSummary].
///
/// See also:
/// * [ValidatableField], for individual form fields that can be validated
/// * [ValidationSummary], for displaying form-level validation errors
class ValidatedForm extends StatefulWidget {
  /// Creates a validated form.
  const ValidatedForm({
    super.key,
    required this.child,
    this.onValidationChanged,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// Called when the validation state of the form changes.
  final ValueChanged<bool>? onValidationChanged;

  @override
  ValidatedFormState createState() => ValidatedFormState();

  /// Finds the [ValidatedFormState] from the closest [ValidatedForm] ancestor.
  static ValidatedFormState of(BuildContext context) {
    final state = context.findAncestorStateOfType<ValidatedFormState>();
    assert(state != null, 'No ValidatedForm found in context');
    return state!;
  }
}

/// The state for a [ValidatedForm] widget.
///
/// Manages a collection of [ValidatableField] widgets and coordinates their
/// validation. This state can be accessed using [ValidatedForm.of].
class ValidatedFormState extends State<ValidatedForm> {
  final Set<ValidatableField> _fields = {};

  /// Registers a field with this form.
  void register(ValidatableField field) {
    _fields.add(field);
  }

  /// Unregisters a field from this form.
  void unregister(ValidatableField field) {
    _fields.remove(field);
  }

  /// Validates all fields in the form and returns whether all validations passed.
  bool validate() {
    bool isValid = true;
    for (final field in _fields) {
      field.validate();
      isValid = isValid && field.error == null;
    }
    widget.onValidationChanged?.call(isValid);
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// A widget that displays a summary of validation errors in a form.
///
/// This widget must be placed below a [ValidatedForm] in the widget tree.
/// It collects validation errors from all [ValidatableField] widgets within
/// the form and displays them.
class ValidationSummary extends StatelessWidget {
  /// Creates a validation summary.
  const ValidationSummary({
    super.key,
    this.errorBuilder,
  });

  /// A builder that creates custom error displays.
  final Widget Function(BuildContext context, List<ValidationError> errors)?
      errorBuilder;

  @override
  Widget build(BuildContext context) {
    final form = ValidatedForm.of(context);
    final errors = form._fields
        .where((field) => field.error != null)
        .map((field) => field.error!)
        .toList();

    if (errors.isEmpty) {
      return const SizedBox.shrink();
    }

    if (errorBuilder != null) {
      return errorBuilder!(context, errors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: errors
          .map((error) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  error.message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ))
          .toList(),
    );
  }
}