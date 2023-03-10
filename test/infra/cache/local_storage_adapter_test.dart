import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

import '../mocks/mocks.dart';

void main() {
  late LocalStorageAdapter sut;
  late LocalStorageSpy localStorage;
  late String key;
  late dynamic value;
  late String result;

  setUp(() {
    result = faker.randomGenerator.string(50);
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);

    localStorage = LocalStorageSpy();
    localStorage.mockFetch(result);
    
    sut = LocalStorageAdapter(localStorage: localStorage);

  });

  group('save', () {
    test('should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);

      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      localStorage.mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('should throw if setItem throws', () async {
      localStorage.mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('should throw if deleteItem throws', () async {
      localStorage.mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('fetch', () {
    test('should call localStorage with correct values', () async {
      await sut.fetch(key);

      verify(() => localStorage.getItem(key)).called(1);
    });

    test('should return same value as localStorage', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });

    test('should throw if deleteItem throws', () async {
      localStorage.mockFetchError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });
}
