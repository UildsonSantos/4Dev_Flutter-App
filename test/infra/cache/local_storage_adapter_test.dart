// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faker/faker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class FlutterSecureStorageSpy extends Mock implements FlutterSecureStorage {}

void main() {
  FlutterSecureStorageSpy secureStorage;
  LocalStorageAdapter sut;
  String key;
  String value;

  setUp(() {
    secureStorage = FlutterSecureStorageSpy();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  group('save secure', () {
    mockSaveSecureError() => when(
            secureStorage.write(key: anyNamed('key'), value: anyNamed('value')))
        .thenThrow(Exception());

    test('should call save secure with correct values', () async {
      await sut.saveSecure(key: key, value: value);

      verify(secureStorage.write(key: key, value: value));
    });

    test('should throw if save secure throws', () async {
      mockSaveSecureError();

      final future = sut.saveSecure(key: key, value: value);

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
      await sut.fetchSecure(key);

      verify(secureStorage.read(key: key));
    });

    test('should return correct value on success', () async {
      final fetchedvalue = await sut.fetchSecure(key);

      expect(fetchedvalue, value);
    });

    test('should throw if fetch secure throws', () async {
      mockFetchSecureError();

      final future = sut.fetchSecure(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
