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
  late RemoteLoadSurveyResult sut;
  late String url;
  late Map surveyResult;
  late String surveyId;

  setUp(() {
    surveyResult = ApiFactory.makeSurveyResultJson();
    surveyId = faker.guid.guid();
    url = faker.internet.httpUrl();

    httpClient = HttpClientSpy();
    httpClient.mockRequest(surveyResult);

    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
  });

  test('should call HttpClient with correct values', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('should return surveys on 200', () async {
    final result = await sut.loadBySurvey(surveyId: surveyId);

    final surveyResultEntity = SurveyResultEntity(
      surveyId: surveyResult['surveyId'],
      question: surveyResult['question'],
      answers: [
        SurveyAnswerEntity(
          image: surveyResult['answers'][0]['image'],
          answer: surveyResult['answers'][0]['answer'],
          isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][0]['percent'],
        ),
        SurveyAnswerEntity(
          answer: surveyResult['answers'][1]['answer'],
          isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
          percent: surveyResult['answers'][1]['percent'],
        )
      ],
    );

    expect(result, surveyResultEntity);
  });

  test(
      'should throw UnexpectedError if HttpClient returns 200 with invalid data',
      () async {
    httpClient.mockRequest(ApiFactory.makeInvalidJson());

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 404', () async {
    httpClient.mockRequestError(HttpError.notFound);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw UnexpectedError if HttpClient returns 500', () async {
    httpClient.mockRequestError(HttpError.serverError);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });

  test('should throw AccessDeniedError if HttpClient returns 403', () async {
    httpClient.mockRequestError(HttpError.forbidden);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });
}
