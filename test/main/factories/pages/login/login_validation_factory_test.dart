import 'package:test/test.dart';

import 'package:fordev/main/factories/pages/pages.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () async {
    final validations = makeLoginValidations();

    expect(validations, [
      RequiredFieldValidation(field: 'email'),
      EmailValidation('email'),
      RequiredFieldValidation(field: 'password'),
      MinLengthValidation(field: 'password', size: 3),
    ]);
  });
}
