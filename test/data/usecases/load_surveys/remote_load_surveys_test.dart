import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';



class HttpClientSpy extends Mock implements HttpClient<List<Map>> {}

void main() {
  HttpClientSpy httpClient;
  RemoteLoadSurveys sut;
  String url;
  List<Map> listToTest;

  List<Map> mockValidData() => [
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        },
        {
          'id': faker.guid.guid(),
          'question': faker.randomGenerator.string(51),
          'didAnswer': faker.randomGenerator.boolean(),
          'date': faker.date.dateTime().toIso8601String(),
        }
      ];

  PostExpectation mockRequest() => when(
        httpClient.request(
          url: anyNamed('url'),
          method: anyNamed('method'),
        ),
      );

  void mockHttpData(List<Map> data) {
    listToTest = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();

    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    mockHttpData(mockValidData());
  });

  test('should call HttpClient with correct values', () async {
    await sut.load();

    verify(httpClient.request(url: url, method: 'get'));
  });

  test('should return surveys on 200', () async {
    final surveys = await sut.load();

    final responseSurveys = [
      SurveyEntity(
        id: listToTest[0]['id'],
        question: listToTest[0]['question'],
        dateTime: DateTime.parse(listToTest[0]['date']),
        didAnswer: listToTest[0]['didAnswer'],
      ),
      SurveyEntity(
        id: listToTest[1]['id'],
        question: listToTest[1]['question'],
        dateTime: DateTime.parse(listToTest[1]['date']),
        didAnswer: listToTest[1]['didAnswer'],
      ),
      SurveyEntity(
        id: listToTest[2]['id'],
        question: listToTest[2]['question'],
        dateTime: DateTime.parse(listToTest[2]['date']),
        didAnswer: listToTest[2]['didAnswer'],
      )
    ];
    expect(surveys, responseSurveys);
  });

  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    mockHttpData([
      {'invalid_key': 'invalid_value'}
    ]);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
