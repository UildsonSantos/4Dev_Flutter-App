import 'package:test/test.dart';

import 'package:fordev/validation/validators/validators.dart';

void main() {
  RequiredFieldValidation sut;

  setUp(() {
    sut = RequiredFieldValidation('any_field');
  });

  test('should return null if value is not empty', () async {
    final error = sut.validate('any_value');

    expect(error, null);
  });

  test('should return error if value is empty', () async {
    final error = sut.validate('');

    expect(error, 'Campo obrigatório');
  });

  test('should return error if value is null', () async {
    final error = sut.validate(null);

    expect(error, 'Campo obrigatório');
  });
}