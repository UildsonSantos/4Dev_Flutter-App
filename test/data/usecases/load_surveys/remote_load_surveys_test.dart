import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late HttpClientSpy httpClient;
  late RemoteLoadSurveys sut;
  late String url;
  late List<Map> listToTest;

  setUp(() {
    listToTest = ApiFactory.makeSurveyList();
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();
    httpClient.mockRequest(listToTest);

    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
  });

  test('should call HttpClient with correct values', () async {
    await sut.load();

    verify(() => httpClient.request(url: url, method: 'get'));
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
    ];
    expect(surveys, responseSurveys);
  });

  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    httpClient.mockRequest(ApiFactory.makeInvalidList());

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
