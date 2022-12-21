import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  GetxSplashPresenter sut;
  LoadCurrentAccountSpy loadCurrentAccount;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentAccountError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(
      account: AccountEntity(token: faker.guid.guid()),
    );
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/surveys')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page on null result', () async {
    mockLoadCurrentAccount(account: null);
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page on null result', () async {
    mockLoadCurrentAccountError();
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });
}
