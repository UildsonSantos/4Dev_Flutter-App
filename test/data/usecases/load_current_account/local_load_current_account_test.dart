import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';
import 'package:meta/meta.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

class LocalLoadCurrentAccount implements LoadCurrentAccount {
  final FetchSecureCacheStorage fetchSecureCacheStorage;

  LocalLoadCurrentAccount({@required this.fetchSecureCacheStorage});

  @override
  Future<AccountEntity> load() async {
    try {
      final token = await fetchSecureCacheStorage.fetchSecure('token');
      return AccountEntity(token);
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}

abstract class FetchSecureCacheStorage {
  Future<String> fetchSecure(String key);
}

class FetchSecureCacheStorageSpy extends Mock
    implements FetchSecureCacheStorage {}

void main() {
  FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  LocalLoadCurrentAccount sut;
  String token;

  PostExpectation mockFetchSecureCall() =>
      when(fetchSecureCacheStorage.fetchSecure(any));

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
    );

    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

    verify(fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('should return an AccountEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('should throw UnexpectedError if FetchSecureCacheStorage throws',
      () async {
    mockFetchSecureError();
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
