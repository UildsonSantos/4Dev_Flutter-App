import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage {}

void main() {
  FetchCacheStorageSpy fetchCacheStorage;
  LocalLoadSurveys sut;
  List<Map> data;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-07-20T00:00:00Z',
          'didAnswer': 'false'
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(10),
          'date': '2019-02-02T00:00:00Z',
          'didAnswer': 'true'
        },
      ];

  PostExpectation mockFetchCall() => when(fetchCacheStorage.fetch(any));

  void mockFetch(List<Map> list) {
    data = list;
    mockFetchCall().thenAnswer((_) async => data);
  }

  void mockFetchError() => mockFetchCall().thenThrow(Exception());

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);

    mockFetch(mockValidData());
  });

  test('should return a list of surveys on success', () async {
    final surveys = await sut.load();

    expect(surveys, [
      SurveyEntity(
        id: data[0]['id'],
        question: data[0]['question'],
        dateTime: DateTime.utc(2020, 7, 20),
        didAnswer: false,
      ),
      SurveyEntity(
        id: data[1]['id'],
        question: data[1]['question'],
        dateTime: DateTime.utc(2018, 2, 2),
        didAnswer: true,
      ),
    ]);
  });

  test('should throw UnexpectedError if cache is empty', () async {
    mockFetch([]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if cache is null', () async {
    mockFetch(null);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if cache is invalid', () async {
    final invalidData = {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': 'invalid date',
      'didAnswer': 'false'
    };
    mockFetch([invalidData]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if cache is incomplete', () async {
    final incompleteData = {
      'date': '2019-07-20T00:00:00Z',
      'didAnswer': 'false'
    };
    mockFetch([incompleteData]);
    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if cache fails', () async {
    mockFetchError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}
