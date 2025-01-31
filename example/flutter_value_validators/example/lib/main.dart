import 'package:flutter/material.dart';
import 'package:flutter_value_validators/flutter_value_validators.dart';
import 'package:flutter_value_validators/src/validators/custom_validator.dart';
import 'package:flutter_value_validators/src/validators/date_validator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Value Validators Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserRegistrationForm(),
    );
  }
}

class UserRegistrationForm extends StatefulWidget {
  const UserRegistrationForm({super.key});

  @override
  State<UserRegistrationForm> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends State<UserRegistrationForm> {
  final _formKey = GlobalKey<ValidatedFormState>();
  
  // Controllers for form fields
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  DateTime? _birthDate;

  final _usernameValidator = StringValidator()
      .required()
      .min(3)
      .max(20)
      .customRule(
        (value) => value.contains(RegExp(r'[A-Z]'))
            ? ValidationResult.success(value)
            : ValidationResult.failure(
                ValidationError(
                  code: 'no_uppercase',
                  message: 'Username must contain at least one uppercase letter',
                ),
              ),
      );

  final _emailValidator = StringValidator()
      .required()
      .email();

  final _ageValidator = NumberValidator()
      .required()
      .integer()
      .minimum(13)
      .maximum(120);

  final _phoneValidator = StringValidator()
      .matches(RegExp(r'^\d{2,4}-?\d{2,4}-?\d{4}$'));

  final _passwordValidator = StringValidator()
      .required()
      .min(8)
      .customRule(
        (value) {
          bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
          bool hasDigits = value.contains(RegExp(r'[0-9]'));
          bool hasSpecialChars = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
          
          if (hasUppercase && hasDigits && hasSpecialChars) {
            return ValidationResult.success(value);
          }
          return ValidationResult.failure(
            ValidationError(
              code: 'weak_password',
              message: 'Password must contain uppercase, numbers, and special characters',
            ),
          );
        },
        code: 'weak_password',
        message: 'Password must contain uppercase, numbers, and special characters',
      );

  // 13歳以上、120歳以下の生年月日を許可
  final _birthDateValidator = DateValidator(
    isRequired: true,
    minDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
    maxDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
  );

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final form = _formKey.currentState!;
    if (form.validate() && _birthDate != null) {
      // Validate birth date
      final birthDateResult = _birthDateValidator.validate(_birthDate);
      if (birthDateResult.isFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(birthDateResult.error!.message),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // All fields are valid, create a user registration data object
      final userData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'age': int.parse(_ageController.text),
        'phone': _phoneController.text.isEmpty ? null : _phoneController.text,
        'password': _passwordController.text,
        'birthDate': _birthDate?.toIso8601String(),
      };
      
      // Show success message with the collected data
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration successful!\n${userData.toString()}'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Here you would typically send the data to a server
      print('User registration data: $userData');
    } else {
      // Show error message if validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 120)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Registration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ValidatedForm(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ValidationSummary(),
              ValidatedTextField(
                controller: _usernameController,
                validator: _usernameValidator,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  helperText: '3-20 characters, must contain uppercase',
                ),
              ),
              const SizedBox(height: 16),
              ValidatedTextField(
                controller: _emailController,
                validator: _emailValidator,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              ValidatedNumberField(
                controller: _ageController,
                validator: _ageValidator,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  helperText: 'Must be between 13 and 120',
                ),
              ),
              const SizedBox(height: 16),
              ValidatedTextField(
                controller: _phoneController,
                validator: _phoneValidator,
                decoration: const InputDecoration(
                  labelText: 'Phone (optional)',
                  helperText: 'Format: 123-4567-8900',
                ),
              ),
              const SizedBox(height: 16),
              ValidatedTextField(
                controller: _passwordController,
                validator: _passwordValidator,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  helperText: 'Must contain uppercase, numbers, and special characters',
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Text('Birth Date', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(_birthDate?.toString().split(' ')[0] ?? 'Not selected'),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
              if (_birthDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  _birthDateValidator.validate(_birthDate).fold(
                    onSuccess: (_) => 'Valid birth date',
                    onFailure: (error) => error.message,
                  ),
                  style: TextStyle(
                    color: _birthDateValidator.validate(_birthDate).isSuccess
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}