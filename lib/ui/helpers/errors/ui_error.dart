import '../helpers.dart';

enum UIError {
  invalidCredentials,
  invalidField,
  requiredField,
  unexpected,
  emailInUse,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return R.strings.msgInvalidCredentials;
      case UIError.invalidField:
        return R.strings.msgInvalidField;
      case UIError.requiredField:
        return R.strings.msgRequiredField;
      case UIError.unexpected:
        return R.strings.msgUnexpectedErro;
      case UIError.emailInUse:
        return R.strings.msgEmailInUse;
      default:
        return R.strings.msgUnexpectedErro;
    }
  }
}
