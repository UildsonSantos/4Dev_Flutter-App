import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  late RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation(field: 'any_field');
  });

  test('should return null if value is not empty', () async {
    final value = sut.validate({'any_field': 'any_value'});

    expect(value, null);
  });

  test('should return error if value is empty', () async {
    final error = sut.validate({'any_field': ''});

    expect(error, ValidationError.requiredField);
  });

  test('should return error if value is null', () async {
    final error = sut.validate({'any_field': null});

    expect(error, ValidationError.requiredField);
  });
}
