import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class ValidationComposite implements Validation {
  final List<FieldValidation> validations;

  ValidationComposite({@required this.validations});

  ValidationError validate({@required String field, @required String value}) {
    ValidationError error;
    for (final validation
        in validations.where((inValidation) => inValidation.field == field)) {
      error = validation.validate(value);
      if (error != null) {
        return error;
      }
    }
    return error;
  }
}
