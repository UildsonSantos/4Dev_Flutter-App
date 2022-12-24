import '../../helpers/errors/errors.dart';

abstract class LoginPresenter {
  Stream<UIError> get emailErrorStream;

  Stream<UIError> get passwordErrorStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingStream;

  Stream<UIError> get mainErrorStream;

  Stream<String> get navigateToStream;

  void validateEmail(String email);

  void validatePassword(String password);

  Future<void> auth();

  void goToSignUp();
}
