import 'package:meta/meta.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';

import 'package:fordev/validation/protocols/field_validation.dart';

class MinLengthValidation implements FieldValidation {
  final String field;
  final int size;

  MinLengthValidation({
    @required this.field,
    @required this.size,
  });

  @override
  ValidationError validate(String value) {
    return ValidationError.invalidField;
  }
}

void main() {
  test('should return error if value is empty', () async {
    final sut = MinLengthValidation(field: 'any_field', size: 5);

    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    final sut = MinLengthValidation(field: 'any_field', size: 5);

    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });
}
