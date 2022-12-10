abstract class LoginPresenter {
  Stream<String> get emailErrorStream;

  Stream<String> get passwordErrorStream;

  Stream<bool> get isFormValidStream;

  Stream<bool> get isLoadingController;

  Stream<String> get mainErrorController;

  void validateEmail(String email);

  void validatePassword(String password);

  void auth();

  void dispose();
}
