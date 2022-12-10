abstract class LoginPresenter {
  Stream get emailErrorStream;

  Stream get passwordErrorStream;

  Stream get isFormValidStream;

  Stream get isLoadingController;

  Stream get mainErrorController;

  void validateEmail(String email);

  void validatePassword(String password);

  void auth();

  void dispose();
}
