import 'package:flutter/material.dart';

import '../../flutter_value_validators.dart';
import 'validated_form.dart';
import 'validatable_field.dart';

/// A text field that integrates with form validation.
///
/// This widget extends [TextField] with validation capabilities, allowing it to
/// participate in form-level validation through [ValidatedForm]. It supports
/// both manual and automatic validation modes.
///
/// See also:
/// * [ValidatedForm], which coordinates validation across multiple fields
/// * [StringValidator], which provides common string validation rules
class ValidatedTextField extends StatefulWidget {
  /// Creates a validated text field.
  const ValidatedTextField({
    super.key,
    required this.validator,
    this.onChanged,
    this.decoration,
    this.controller,
    this.errorBuilder,
    this.autovalidate = false,
    this.obscureText = false,
  });

  /// The validator used to validate the field's value.
  final Validator<String> validator;

  /// Called when the user changes the text in the field.
  final ValueChanged<String>? onChanged;

  /// The decoration to show around the text field.
  final InputDecoration? decoration;

  /// Controls the text being edited.
  final TextEditingController? controller;

  /// A builder that creates custom error displays.
  final Widget Function(BuildContext context, ValidationError error)? errorBuilder;

  /// Whether to validate the field whenever its value changes.
  final bool autovalidate;

  /// Whether to hide the text being edited.
  final bool obscureText;

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField>
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

  @override
  bool validate() {
    final result = widget.validator.validate(_controller.text);
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
          obscureText: widget.obscureText,
          onChanged: (value) {
            if (widget.autovalidate) {
              validate();
            }
            widget.onChanged?.call(value);
          },
        ),
        if (_error != null && widget.errorBuilder != null)
          widget.errorBuilder!(context, _error!),
      ],
    );
  }
}