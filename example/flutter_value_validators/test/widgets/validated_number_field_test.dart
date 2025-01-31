import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_value_validators/flutter_value_validators.dart';

void main() {
  group('ValidatedNumberField', () {
    testWidgets('allows integer input', (tester) async {
      final validator = NumberValidator();
      num? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidatedForm(
              child: ValidatedNumberField(
                validator: validator,
                onChanged: (value) => changedValue = value,
                allowDecimal: false,
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, '42');
      expect(changedValue, equals(42));

      // 小数点は入力できないはず
      await tester.enterText(textField, '42.5');
      expect(find.text('42.5'), findsNothing);
    });

    testWidgets('allows decimal input', (tester) async {
      final validator = NumberValidator();
      num? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidatedForm(
              child: ValidatedNumberField(
                validator: validator,
                onChanged: (value) => changedValue = value,
                allowDecimal: true,
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, '3.14');
      expect(changedValue, equals(3.14));
    });

    testWidgets('shows validation errors', (tester) async {
      final validator = NumberValidator()
          .required()
          .minimum(0)
          .maximum(100);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidatedForm(
              child: ValidatedNumberField(
                validator: validator,
                autovalidate: true,
                decoration: const InputDecoration(),
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      
      // 範囲外の値
      await tester.enterText(textField, '101');
      await tester.pump();
      expect(find.text('Value must be less than or equal to 100'), findsOneWidget);

      // 有効な値
      await tester.enterText(textField, '42');
      await tester.pump();
      expect(find.text('Value must be less than or equal to 100'), findsNothing);
    });

    testWidgets('custom error builder', (tester) async {
      final validator = NumberValidator().required();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ValidatedForm(
              child: ValidatedNumberField(
                validator: validator,
                autovalidate: true,
                errorBuilder: (context, error) => Text('Custom: ${error.message}'),
              ),
            ),
          ),
        ),
      );

      final textField = find.byType(TextField);
      await tester.enterText(textField, '');
      await tester.pump();
      expect(find.text('Custom: Value is required'), findsOneWidget);
    });
  });
}