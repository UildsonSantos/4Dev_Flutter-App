import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {
  late FlutterSecureStorageSpy secureStorage;
  late SecureStorageAdapter sut;
  late String key;
  late String value;

  setUp(() {
    key = faker.lorem.word();
    value = faker.guid.guid();

    secureStorage = FlutterSecureStorageSpy();
    secureStorage.mockFetchSecure(value);

    sut = SecureStorageAdapter(secureStorage: secureStorage);
  });

  group('save secure', () {
    test('should call save secure with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => secureStorage.write(key: key, value: value));
    });

    test('should throw if save secure throws', () async {
      secureStorage.mockSaveSecureError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch secure', () {
    test('should call fetch secure with correct values', () async {
      await sut.fetch(key);

      verify(() => secureStorage.read(key: key));
    });

    test('should return correct value on success', () async {
      final fetchedvalue = await sut.fetch(key);

      expect(fetchedvalue, value);
    });

    test('should throw if fetch secure throws', () async {
      secureStorage.mockFetchSecureError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete secure', () {
    test('should call delete with correct key', () async {
      await sut.delete(key);

      verify(() => secureStorage.delete(key: key)).called(1);
    });

    test('should throw if delete throws', () async {
      secureStorage.mockDeleteSecureError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
