import 'package:faker/faker.dart';
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
    return value?.length == size ? null : ValidationError.invalidField;
  }
}

void main() {
  MinLengthValidation sut;
  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('should return error if value is empty', () async {
    final error = sut.validate('');

    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    final error = sut.validate(null);

    expect(error, ValidationError.invalidField);
  });

  test('should return error if value is less than min size', () async {
    final smallerSizeTypeError = sut.validate(
      faker.randomGenerator.string(4, min: 1),
    );

    expect(smallerSizeTypeError, ValidationError.invalidField);
  });

  test('should return null if value is equal than min size', () async {
    final equalMinSizeValue = sut.validate(
      faker.randomGenerator.string(5, min: 5),
    );

    expect(equalMinSizeValue, null);
  });
}
