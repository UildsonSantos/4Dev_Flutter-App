import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../presentation/protocols/protocols.dart';
import '../protocols/protocols.dart';

class RequiredFieldValidation extends Equatable implements FieldValidation {
  final String field;

  RequiredFieldValidation({@required this.field});

  @override
  List<Object> get props => [field];

  ValidationError validate(String value) =>
      value?.isNotEmpty == true ? null : ValidationError.requiredField;
}
