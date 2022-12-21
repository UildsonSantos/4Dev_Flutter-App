enum UIError {
  invalidCredentials,
  invalidField,
  requiredField,
  unexpected,
}

extension UIErrorExtension on UIError {
  String get description {
    switch (this) {
      case UIError.invalidCredentials:
        return 'Credenciais inválidas';
      case UIError.invalidField:
        return 'Campo inválido';
      case UIError.requiredField:
        return 'Campo obrigatório';
      case UIError.unexpected:
        return 'Algo inesperado aconteceu! Tente novamente mais tarde.';
      default:
        return 'Algo errado aconteceu. Tente novamente em breve.';
    }
  }
}
