abstract class LoginPresenter {
  Stream get emailErrorStream;

  Stream get passwordErrorStream;

  Stream get isFormValidStream;

  Stream get isLoadingController;

  void validateEmail(String email);

  void validatePassword(String password);

  void auth();
}
