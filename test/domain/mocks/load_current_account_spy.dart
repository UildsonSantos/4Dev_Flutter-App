import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {
  When mockLoadCurrentAccountCall() => when(() => this.load());

  void mockLoadCurrentAccount({required AccountEntity account}) =>
      this.mockLoadCurrentAccountCall().thenAnswer((_) async => account);

  void mockLoadCurrentAccountError() =>
      this.mockLoadCurrentAccountCall().thenThrow(Exception());
}
