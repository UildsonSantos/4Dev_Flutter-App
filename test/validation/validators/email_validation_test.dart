import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/validation.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  EmailValidation sut;

  setUp(() {
    sut = EmailValidation('any_field');
  });

  test('should return null if email is empty', () {
    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final error = sut.validate(null);

    expect(error, null);
  });

  test('should return null if email is valid', () {
    final error = sut.validate('occursum.o@gmail.com');

    expect(error, null);
  });

  test('should return error if email is invalid', () {
    final error = sut.validate('occursum.o');

    expect(error, ValidationError.invalidField);
  });
}
