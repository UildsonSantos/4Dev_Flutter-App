import 'package:faker/faker.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

abstract class Validation {
  void validate({
    @required String field,
    @required String value,
  });
}

class StreamLoginPresenter {
  final Validation validation;

  StreamLoginPresenter({@required this.validation});

  void validateEmail(String email) {
    validation.validate(field: 'email', value: email);
  }
}

class ValidationSpy extends Mock implements Validation {}

void main() {
  StreamLoginPresenter sut;
  Validation validation;
  String email;

  setUp(() {
    validation = ValidationSpy();
    sut = StreamLoginPresenter(validation: validation);
    email = faker.internet.email();
  });

  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });
}
