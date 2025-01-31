import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../flutter_value_validators.dart';
import 'validated_form.dart';
import 'validatable_field.dart';

/// A text field that validates numeric input using a [NumberValidator].
///
/// This widget extends [TextField] with validation capabilities specifically for
/// numeric input. It supports both integer and decimal input modes, and integrates
/// with form-level validation through [ValidatedForm].
///
/// See also:
/// * [ValidatedForm], which coordinates validation across multiple fields
/// * [NumberValidator], which provides common numeric validation rules
/// * [ValidatedTextField], for validating text input
class ValidatedNumberField extends StatefulWidget {
  /// Creates a validated number field.
  const ValidatedNumberField({
    super.key,
    required this.validator,
    this.onChanged,
    this.decoration,
    this.controller,
    this.errorBuilder,
    this.autovalidate = false,
    this.allowDecimal = true,
  });

  /// The validator for the numeric input.
  final Validator<num> validator;

  /// Called when the user changes the input.
  ///
  /// The callback receives null if the input is empty or not a valid number.
  final ValueChanged<num?>? onChanged;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// Builds the error widget when validation fails.
  final Widget Function(BuildContext context, ValidationError error)? errorBuilder;

  /// Whether to validate on every change.
  final bool autovalidate;

  /// Whether to allow decimal numbers.
  ///
  /// When set to false, only integer input is allowed.
  final bool allowDecimal;

  @override
  State<ValidatedNumberField> createState() => _ValidatedNumberFieldState();
}

/// The state for a [ValidatedNumberField] widget.
class _ValidatedNumberFieldState extends State<ValidatedNumberField>
    implements ValidatableField {
  late final TextEditingController _controller;
  ValidationError? _error;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    ValidatedForm.of(context).register(this);
  }

  @override
  void dispose() {
    ValidatedForm.of(context).unregister(this);
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  ValidationError? get error => _error;

  /// Parses the text input as a number.
  ///
  /// Returns null if the input is empty or not a valid number.
  num? _parseNumber(String value) {
    if (value.isEmpty) {
      return null;
    }
    try {
      return widget.allowDecimal ? double.parse(value) : int.parse(value);
    } on FormatException {
      return null;
    }
  }

  @override
  bool validate() {
    final number = _parseNumber(_controller.text);
    final result = widget.validator.validate(number);
    setState(() {
      _error = result.error;
    });
    return result.isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _controller,
          decoration: widget.decoration?.copyWith(
            errorText: _error?.message,
          ),
          keyboardType: TextInputType.numberWithOptions(
            decimal: widget.allowDecimal,
            signed: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              widget.allowDecimal
                  ? RegExp(r'^\-?\d*\.?\d*$')
                  : RegExp(r'^\-?\d*$'),
            ),
          ],
          onChanged: (value) {
            if (widget.autovalidate) {
              validate();
            }
            final number = _parseNumber(value);
            widget.onChanged?.call(number);
          },
        ),
        if (_error != null && widget.errorBuilder != null)
          widget.errorBuilder!(context, _error!),
      ],
    );
  }
}