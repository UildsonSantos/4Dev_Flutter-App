import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/main/composites/composites.dart';

import '../../data/mocks/mocks.dart';
import '../../domain/mocks/mocks.dart';

void main() {
  late LocalLoadSurveyResultSpy local;
  late RemoteLoadSurveyResultWithLocalFallback sut;
  late RemoteLoadSurveyResultSpy remote;
  late String surveyId;
  late SurveyResultEntity localSurveyResult;
  late SurveyResultEntity remoteSurveyResult;

  setUp(() {
    surveyId = faker.guid.guid();

    localSurveyResult = EntityFactory.makeSurveyResult();
    local = LocalLoadSurveyResultSpy();
    local.mockLoadBySurvey(localSurveyResult);

    remoteSurveyResult = EntityFactory.makeSurveyResult();
    remote = RemoteLoadSurveyResultSpy();
    remote.mockLoadBySurvey(remoteSurveyResult);

    sut = RemoteLoadSurveyResultWithLocalFallback(remote: remote, local: local);
  });

  setUpAll(() {
    registerFallbackValue(EntityFactory.makeSurveyResult());
  });

  test('should call remote loadBySurvey', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => remote.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should call local save with remote data', () async {
    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.save(surveyResult: remoteSurveyResult)).called(1);
  });

  test('should return remote data', () async {
    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, remoteSurveyResult);
  });
  test('should rethrow if remote loadBySurvey throws AccessDeniedError',
      () async {
    remote.mockLoadBySurveyError(DomainError.accessDenied);

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('should call local loadBySurvey on remote error', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    await sut.loadBySurvey(surveyId: surveyId);

    verify(() => local.validate(surveyId)).called(1);
    verify(() => local.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should return local surveyResult', () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);

    final response = await sut.loadBySurvey(surveyId: surveyId);

    expect(response, localSurveyResult);
  });

  test('should throw UnexpectedError if remote and local loadBySurvey throws',
      () async {
    remote.mockLoadBySurveyError(DomainError.unexpected);
    local.mockLoadBySurveyError();

    final future = sut.loadBySurvey(surveyId: surveyId);

    expect(future, throwsA(DomainError.unexpected));
  });
}
