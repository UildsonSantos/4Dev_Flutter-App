import 'package:fordev/validation/protocols/protocols.dart';
import 'package:test/test.dart';

class EmailValidation implements FieldValidation {
  @override
  String field;

  EmailValidation(this.field);

  String validate(String value) {
    return null;
  }
}

void main() {
  test('should return null if email is empty', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate('');

    expect(error, null);
  });

  test('should return null if email is null', () {
    final sut = EmailValidation('any_field');

    final error = sut.validate(null);

    expect(error, null);
  });
}
