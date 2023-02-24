import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late MinLengthValidation sut;
  setUp(() {
    sut = MinLengthValidation(field: 'any_field', size: 5);
  });

  test('should return error if value is empty', () async {
    final valueEmptyError = sut.validate({'any_field': ''});

    expect(valueEmptyError, ValidationError.invalidField);
  });

  test('should return error if value is null', () async {
    final valueNullError = sut.validate({'any_field': null});

    expect(valueNullError, ValidationError.invalidField);
  });

  test('should return error if value is less than min size', () async {
    final smallerSizeLengthError = sut.validate({
      'any_field': faker.randomGenerator.string(4, min: 1),
    });

    expect(smallerSizeLengthError, ValidationError.invalidField);
  });

  test('should return null if value is equal than min size', () async {
    final equalMinSizeValue = sut.validate({
      'any_field': faker.randomGenerator.string(5, min: 5),
    });

    expect(equalMinSizeValue, null);
  });

  test('should return null if value is bigger than min size', () async {
    final biggerThanMinSizeValue = sut.validate({
      'any_field': faker.randomGenerator.string(13, min: 6),
    });

    expect(biggerThanMinSizeValue, null);
  });
}
