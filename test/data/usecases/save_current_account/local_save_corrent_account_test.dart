import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

class SaveSecureCacheStorageSpy extends Mock implements SaveSecureCacheStorage {
}

void main() {
  LocalSaveCurrentAccount sut;
  SaveSecureCacheStorageSpy saveSecureCacheStorage;
  AccountEntity account;

  void mockError() {
    when(saveSecureCacheStorage.save(
      key: anyNamed('key'),
      value: anyNamed('value'),
    )).thenThrow(Exception());
  }

  setUp(() {
    saveSecureCacheStorage = SaveSecureCacheStorageSpy();
    sut = LocalSaveCurrentAccount(
      saveSecureCacheStorage: saveSecureCacheStorage,
    );

    account = AccountEntity(token: faker.guid.guid());
  });

  test('should call SaveSecureCacheStorage with correct values', () async {
    await sut.save(account);

    verify(
      saveSecureCacheStorage.save(key: 'token', value: account.token),
    );
  });

  test('should throw UnexpectedError if SaveSecureCacheStorage throws', () {
    mockError();
    final future = sut.save(account);

    expect(future, throwsA(DomainError.unexpected));
  });
}
