import '../../../../presentation/protocols/protocols.dart';
import '../../../../validation/protocols/protocols.dart';
import '../../../../validation/validators/validators.dart';
import '../../../builders/builders.dart';

Validation makeLoginValidation() =>
    ValidationComposite(validations: makeLoginValidations());

List<FieldValidation> makeLoginValidations() => [
      ...ValidationBuilder.field('email').required().email().build(),
      ...ValidationBuilder.field('password').required().minLengthSize(3).build()
    ];
