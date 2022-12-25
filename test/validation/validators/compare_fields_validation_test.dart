import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  CompareFieldsValidation sut;

  setUp(() {
    sut = CompareFieldsValidation(
      field: 'any_field',
      fieldToCompare: 'other_field',
    );
  });

  test('should return error if values are not equal', () async {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'other_value',
    };

    final differentValuesError = sut.validate(formData);

    expect(differentValuesError, ValidationError.invalidField);
  });

  test('should return null if values are equal', () async {
    final formData = {
      'any_field': 'any_value',
      'other_field': 'any_value',
    };

    final equalValues = sut.validate(formData);

    expect(equalValues, null);
  });
}
