import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      valueToCompare: 'any_value',
    );
  });

  test('should return error if values are not equal', () async {
    final differentValuesError = sut.validate('wrong_value');

    expect(differentValuesError, ValidationError.invalidField);
  });

  test('should return null if values are equal', () async {
    final equalValues = sut.validate('any_value');

    expect(equalValues, null);
  });
}
