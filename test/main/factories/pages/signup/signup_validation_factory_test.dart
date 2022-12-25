import 'package:test/test.dart';

import 'package:fordev/main/factories/pages/pages.dart';
import 'package:fordev/validation/validators/validators.dart';

void main() {
  test('should return the correct validations', () async {
    final validations = makeSignUpValidations();

    expect(validations, [
      RequiredFieldValidation(field: 'name'),
      MinLengthValidation(field: 'name', size: 3),
      RequiredFieldValidation(field: 'email'),
      EmailValidation('email'),
      RequiredFieldValidation(field: 'password'),
      MinLengthValidation(field: 'password', size: 3),
      RequiredFieldValidation(field: 'passwordConfirmation'),
      CompareFieldsValidation(
          field: 'passwordConfirmation', fieldToCompare: 'password')
    ]);
  });
}
