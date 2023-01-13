import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/protocols/protocols.dart';

import 'package:fordev/validation/protocols/protocols.dart';

import 'package:fordev/main/composites/composites.dart';

class FieldValidationSpy extends Mock implements FieldValidation {}

void main() {
  ValidationComposite sut;
  FieldValidationSpy validation1;
  FieldValidationSpy validation2;
  FieldValidationSpy validation3;

  void mockValidation1(ValidationError error) =>
      when(validation1.validate(any)).thenReturn(error);

  void mockValidation2(ValidationError error) =>
      when(validation2.validate(any)).thenReturn(error);

  void mockValidation3(ValidationError error) =>
      when(validation3.validate(any)).thenReturn(error);

  setUp(() {
    validation1 = FieldValidationSpy();
    when(validation1.field).thenReturn('other_field');
    mockValidation1(null);

    validation2 = FieldValidationSpy();
    when(validation2.field).thenReturn('any_field');
    mockValidation2(null);

    validation3 = FieldValidationSpy();
    when(validation3.field).thenReturn('any_field');
    mockValidation3(null);
    sut = ValidationComposite(validations: [
      validation1,
      validation2,
      validation3,
    ]);
  });

  test('should return null if all validations returns null or empty', () {
    final error =
        sut.validate(field: 'any_field', input: {'any_field': 'any_value'});

    expect(error, null);
  });

  test('should return the first error', () {
    mockValidation1(ValidationError.requiredField);
    mockValidation2(ValidationError.invalidField);
    mockValidation3(ValidationError.requiredField);

    final error =
        sut.validate(field: 'any_field', input: {'any_field': 'any_value'});

    expect(error, ValidationError.invalidField);
  });
}
