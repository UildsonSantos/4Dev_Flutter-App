import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../builders/builders.dart';
import '../../../composites/composites.dart';

Validation makeSignUpValidation() =>
    ValidationComposite(validations: makeSignUpValidations());

List<FieldValidation> makeSignUpValidations() => [
      ...ValidationBuilder.field('name').required().minLengthSize(3).build(),
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password')
          .required()
          .minLengthSize(3)
          .build(),
      ...ValidationBuilder.field('passwordConfirmation')
          .required()
          .sameAs('password')
          .build(),
    ];
