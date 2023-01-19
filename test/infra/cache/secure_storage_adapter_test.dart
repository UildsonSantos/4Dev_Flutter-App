import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  SecureStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = SecureStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save secure', () {
    mockSaveSecureError() => when(
            secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    test('should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch secure', () {
    PostExpectation mockFetchSecureCall() =>
        when(secureStorage.read(key: anyNamed('key')));

    mockFetchSecureError() => mockFetchSecureCall().thenThrow(Exception());

    mockFetchSecure() => mockFetchSecureCall().thenAnswer((_) async => value);

    setUp(() {
      mockFetchSecure();
    });

    test('should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(secureStorage.read(key: key));
    });

    test('should return correct value on success', () async {
      final fetchedvalue = await sut.fetch(key);

      expect(fetchedvalue, value);
    });

    test('should throw if fetch secure throws', () async {
      mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete secure', () {
    mockDeleteAecureError() =>
        when(secureStorage.delete(key: anyNamed('key'))).thenThrow(Exception());

    test('should call delete with correct key', () async {
      await sut.delete(key);

      verify(secureStorage.delete(key: key)).called(1);
    });

    test('should throw if delete throws', () async {
      mockDeleteAecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
