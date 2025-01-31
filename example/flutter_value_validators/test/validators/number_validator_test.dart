import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_value_validators/flutter_value_validators.dart';

void main() {
  group('NumberValidator', () {
    test('default validator accepts any number', () {
      final validator = NumberValidator();
      expect(validator.validate(0).isSuccess, isTrue);
      expect(validator.validate(42).isSuccess, isTrue);
      expect(validator.validate(-1).isSuccess, isTrue);
      expect(validator.validate(3.14).isSuccess, isTrue);
    });

    test('required validator', () {
      final validator = NumberValidator().required();
      expect(validator.validate(0).isSuccess, isTrue);
      expect(validator.validate(null).isFailure, isTrue);
      expect(validator.validate(null).error?.code, equals('required'));
    });

    test('integer validator', () {
      final validator = NumberValidator().integer();
      expect(validator.validate(42).isSuccess, isTrue);
      expect(validator.validate(3.14).isFailure, isTrue);
      expect(validator.validate(3.14).error?.code, equals('not_integer'));
      expect(validator.validate(3.0).isSuccess, isTrue);  // 整数値の浮動小数点数は許可
    });

    group('range validation', () {
      test('minimum value', () {
        final validator = NumberValidator().minimum(10);
        expect(validator.validate(9).isFailure, isTrue);
        expect(validator.validate(9).error?.code, equals('less_than_minimum'));
        expect(validator.validate(10).isSuccess, isTrue);
        expect(validator.validate(11).isSuccess, isTrue);
      });

      test('maximum value', () {
        final validator = NumberValidator().maximum(10);
        expect(validator.validate(11).isFailure, isTrue);
        expect(validator.validate(11).error?.code, equals('greater_than_maximum'));
        expect(validator.validate(10).isSuccess, isTrue);
        expect(validator.validate(9).isSuccess, isTrue);
      });

      test('range validation', () {
        final validator = NumberValidator()
            .minimum(0)
            .maximum(100);
        expect(validator.validate(-1).isFailure, isTrue);
        expect(validator.validate(0).isSuccess, isTrue);
        expect(validator.validate(50).isSuccess, isTrue);
        expect(validator.validate(100).isSuccess, isTrue);
        expect(validator.validate(101).isFailure, isTrue);
      });
    });

    test('combined validations', () {
      final validator = NumberValidator()
          .required()
          .integer()
          .minimum(0)
          .maximum(100);

      // Valid cases
      expect(validator.validate(0).isSuccess, isTrue);
      expect(validator.validate(42).isSuccess, isTrue);
      expect(validator.validate(100).isSuccess, isTrue);

      // Invalid cases
      expect(validator.validate(null).isFailure, isTrue);
      expect(validator.validate(-1).isFailure, isTrue);
      expect(validator.validate(101).isFailure, isTrue);
      expect(validator.validate(3.14).isFailure, isTrue);
    });

    test('validation result values', () {
      final validator = NumberValidator().minimum(10);
      
      final successResult = validator.validate(42);
      expect(successResult.isSuccess, isTrue);
      expect(successResult.value, equals(42));
      expect(successResult.error, isNull);

      final failureResult = validator.validate(5);
      expect(failureResult.isFailure, isTrue);
      expect(failureResult.value, isNull);
      expect(failureResult.error?.code, equals('less_than_minimum'));
    });
  });
}