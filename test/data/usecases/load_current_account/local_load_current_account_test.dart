import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../mocks/mocks.dart';

void main() {
  late SecureCacheStorageSpy secureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  setUp(() {
    token = faker.guid.guid();    
    secureCacheStorage = SecureCacheStorageSpy();
    secureCacheStorage.mockFetch(token);

    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: secureCacheStorage,
    );
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(() => secureCacheStorage.fetch('token'));
  });

  test('should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token: token));
  });

  test('should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    secureCacheStorage.mockFetchError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if FetchSecureCacheStorage returns null',
      () async {
    secureCacheStorage.mockFetch(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
