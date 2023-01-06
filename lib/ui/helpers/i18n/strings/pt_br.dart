import 'translations.dart';

class PtBr implements Translations {
  @override
  String get msgEmailInUse => 'O email já está em uso.';

  @override
  String get msgInvalidCredentials => 'Credenciais inválidas';

  @override
  String get msgInvalidField => 'Campo inválido';

  @override
  String get msgRequiredField => 'Campo obrigatório';

  @override
  String get msgUnexpectedErro =>
      'Algo inesperado aconteceu! Tente novamente mais tarde.';

  @override
  String get addAccount => 'Criar conta';

  @override
  String get confirmPassword => 'Confirme sua senha';

  @override
  String get email => 'Email';

  @override
  String get enter => 'Entrar';

  @override
  String get login => 'Login';

  @override
  String get name => 'Nome';

  @override
  String get password => 'Senha';

  @override
  String get reload => 'Recarregar';

  @override
  String get surveys => 'Enquetes';

  @override
  String get wait => 'Aguarde...';
}
