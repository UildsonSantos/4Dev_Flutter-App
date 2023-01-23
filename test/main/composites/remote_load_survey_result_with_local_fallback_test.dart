import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';

class LocalLoadSurveyResultSpy extends Mock implements LocalLoadSurveyResult {}

class RemoteLoadSurveyResultSpy extends Mock implements RemoteLoadSurveyResult {
}

void main() {
  LocalLoadSurveyResultSpy local;
  RemoteLoadSurveyResultWithLocalFallback sut;
  RemoteLoadSurveyResultSpy remote;
  String surveyId;
  SurveyResultEntity localSurveyResult;
  SurveyResultEntity remoteSurveyResult;

  SurveyResultEntity mockSurveyResult() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean(),
            )
          ]);

  PostExpectation mockRemoteLoadBySurveyCall() =>
      when(remote.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockRemoteLoadBySurvey() {
    remoteSurveyResult = mockSurveyResult();
    mockRemoteLoadBySurveyCall().thenAnswer((_) async => remoteSurveyResult);
  }

  void mockRemoteLoadBySurveyError(DomainError error) =>
      mockRemoteLoadBySurveyCall().thenThrow(error);

  PostExpectation mockLocalLoadBySurveyCall() =>
      when(local.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLocalLoadBySurvey() {
    localSurveyResult = mockSurveyResult();
    mockLocalLoadBySurveyCall().thenAnswer((_) async => localSurveyResult);
  }

  void mockLocalLoadBySurveyError() =>
      mockLocalLoadBySurveyCall().thenThrow(DomainError.unexpected);

  setUp(() {
    local = LocalLoadSurveyResultSpy();
    surveyId = faker.guid.guid();
    remote = RemoteLoadSurveyResultSpy();
    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
    mockRemoteLoadBySurvey();
    mockLocalLoadBySurvey();
  });

  test('should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.save(surveyResult: remoteSurveyResult)).called(1);
  });

  test('should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteSurveyResult);
  });
  test('should rethrow if remote loadBySurvey throws AccessDeniedError',
      () async {
    mockRemoteLoadBySurveyError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local loadBySurvey on remote error', () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(local.validate(surveyId)).called(1);
    verify(local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should return local surveyResult', () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localSurveyResult);
  });

  test('should throw UnexpectedError if remote and local loadBySurvey throws',
      () async {
    mockRemoteLoadBySurveyError(DomainError.unexpected);
    mockLocalLoadBySurveyError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
