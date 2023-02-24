import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import '../../domain/mocks/mocks.dart';

void main() {
  late GetxSplashPresenter sut;
  late LoadCurrentAccountSpy loadCurrentAccount;

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    loadCurrentAccount.mockLoadCurrentAccount(
        account: EntityFactory.makeAccount());

    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
  });

  setUpAll(() {
    registerFallbackValue(ParamsFactory.makeAddAccount());
    registerFallbackValue(EntityFactory.makeAccount());
  });

  test('should call LoadCurrentAccount', () async {
    await sut.checkAccount(durationInSeconds: 0);

    verify(() => loadCurrentAccount.load()).called(1);
  });

  test('should go to surveys page on success', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/surveys')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });

  test('should go to login page on null result', () async {
    loadCurrentAccount.mockLoadCurrentAccountError();
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/login')),
    );

    await sut.checkAccount(durationInSeconds: 0);
  });
}
