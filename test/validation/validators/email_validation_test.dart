import 'package:fordev/validation/protocols/protocols.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  @override
  String field;

  EmailValidation(this.field);

  String validate(String value) {
    final regex = RegExp(
        r"^[a-zA-Z0-9.a-zA-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

    final isValid = value?.isNotEmpty != true || regex.hasMatch(value);
    return isValid ? null : 'Campo inválido';
  }
}

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

    expect(error, 'Campo inválido');
  });
}
