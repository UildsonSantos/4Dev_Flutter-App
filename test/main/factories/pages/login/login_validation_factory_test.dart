import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/main/factories/pages/login/login.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () async {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation('email'),
      EmailValidation('email'),
      RequiredFieldValidation('password')
    ]);
  });
}
