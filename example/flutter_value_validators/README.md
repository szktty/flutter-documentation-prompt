# flutter_value_validators

A Flutter package for value validation with form widgets.

## Features

- Fluent API for building validation rules
- Built-in validators for common types (string, number, date)
- Form widgets with validation support
- Custom validator support

## Sample Application

The sample application showcasing the usage of this package can be found at:
```
/example/lib/main.dart
```

The sample app implements a user registration form that demonstrates:
- String validation with custom rules (username with uppercase requirement)
- Email validation
- Number validation (age restrictions)
- Phone number format validation
- Password validation with complex rules (uppercase, numbers, special characters)
- Date validation (birth date with age restrictions)
- Form-level validation with error summary

## Documentation

The source code documentation comments in this package were generated following a structured documentation prompt, which ensures:
- Consistent documentation style across all components
- Clear and concise explanations focused on behavior rather than implementation
- Proper cross-referencing between related components
- Inclusion of relevant examples where necessary
- Emphasis on API relationships and constraints

## Usage

### Basic Validation

```dart
// String validation
final validator = StringValidator()
  .required()
  .minLength(3)
  .maxLength(50)
  .email();

final result = validator.validate("test@example.com");
print(result.isSuccess); // true

// Number validation
final numberValidator = NumberValidator()
  .required()
  .min(0)
  .max(100)
  .integer();

// Date validation
final dateValidator = DateValidator()
  .required()
  .after(DateTime.now())
  .before(DateTime.now().add(Duration(days: 30)));

// Custom validation
final customValidator = Validator<String>()
  .custom((value) {
    if (value.contains("test")) {
      return ValidationResult.success(value);
    }
    return ValidationResult.failure(
      ValidationError(
        code: "contains_test",
        message: "Value must contain 'test'"
      )
    );
  });
```

### Form Widgets

```dart
ValidatedTextField(
  validator: StringValidator()
    .required()
    .email(),
  onChanged: (value) {
    // Handle value change
  },
);

ValidatedForm(
  child: Column(
    children: [
      ValidatedTextField(
        validator: StringValidator().required(),
        // ...
      ),
      ValidatedTextField(
        validator: NumberValidator()
          .required()
          .min(0),
        // ...
      ),
      ValidationSummary(), // Shows all validation errors
      ElevatedButton(
        onPressed: () {
          if (ValidatedForm.of(context).validate()) {
            // Form is valid, proceed with submission
          }
        },
        child: Text('Submit'),
      ),
    ],
  ),
);
```

### Working with Results

```dart
final result = validator.validate(value);

// Using fold
final message = result.fold(
  onSuccess: (value) => "Valid: $value",
  onFailure: (error) => "Error: ${error.message}"
);

// Pattern matching
if (result.isSuccess) {
  final value = result.value;
  // Handle success
} else {
  final error = result.error;
  // Handle error
}
```

## Widgets

- `ValidatedTextField`: A text field with built-in validation support
- `ValidatedForm`: A form widget that manages multiple validated fields
- `ValidationSummary`: Displays a summary of all validation errors in a form
- `ValidationErrorText`: Displays a single validation error message

## Custom Validators

```dart
class PhoneValidator extends Validator<String> {
  ValidationResult<String> validate(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationResult.failure(
        ValidationError(
          code: "required",
          message: "Phone number is required"
        )
      );
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]+$');
    if (!phoneRegex.hasMatch(value)) {
      return ValidationResult.failure(
        ValidationError(
          code: "invalid_phone",
          message: "Invalid phone number format"
        )
      );
    }

    return ValidationResult.success(value);
  }
}
```