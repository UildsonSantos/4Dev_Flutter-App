import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../../domain/mocks/mocks.dart';
import '../../../infra/mocks/mocks.dart';
import '../../mocks/mocks.dart';

void main() {
  late CacheStorageSpy cacheStorage;
  late LocalLoadSurveyResult sut;
  late Map data;
  late String surveyId;
  late SurveyResultEntity surveyResult;

  setUp(() {
    surveyId = faker.guid.guid();
    surveyResult = EntityFactory.makeSurveyResult();

    data = CacheFactory.makeSurveyResult();
    cacheStorage = CacheStorageSpy();
    cacheStorage.mockFetch(data);

    sut = LocalLoadSurveyResult(cacheStorage: cacheStorage);
  });

  group('loadBySurvey', () {
    test('should call caheStorage with correct key', () async {
      await sut.loadBySurvey(surveyId: surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('should return surveyResult on success', () async {
      final surveyResult = await sut.loadBySurvey(surveyId: surveyId);

      expect(
        surveyResult,
        SurveyResultEntity(
          surveyId: data['surveyId'],
          question: data['question'],
          answers: [
            SurveyAnswerEntity(
              image: data['answers'][0]['image'],
              answer: data['answers'][0]['answer'],
              percent: 40,
              isCurrentAnswer: true,
            ),
            SurveyAnswerEntity(
              answer: data['answers'][1]['answer'],
              percent: 60,
              isCurrentAnswer: false,
            )
          ],
        ),
      );
    });

    test('should throw UnexpectedError if cache is empty', () async {
      cacheStorage.mockFetch({});
      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });

    test('should throw UnexpectedError if cache throws', () async {
      cacheStorage.mockFetchError();

      final future = sut.loadBySurvey(surveyId: surveyId);

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    test('should call cacheStorage with correct key', () async {
      await sut.validate(surveyId);

      verify(() => cacheStorage.fetch('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is invalid', () async {
      cacheStorage.mockFetch(CacheFactory.makeInvalidSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it is incomplete', () async {
      cacheStorage.mockFetch(CacheFactory.makeIncompleteSurveyResult());

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });

    test('should delete cache if it throws', () async {
      cacheStorage.mockFetchError();

      await sut.validate(surveyId);

      verify(() => cacheStorage.delete('survey_result/$surveyId')).called(1);
    });
  });

  group('save', () {
    test('Should call cacheStorage with correct values', () async {
      Map json = {
        'surveyId': surveyResult.surveyId,
        'question': surveyResult.question,
        'answers': [
          {
            'image': surveyResult.answers[0].image,
            'answer': surveyResult.answers[0].answer,
            'percent': '40',
            'isCurrentAnswer': 'true'
          },
          {
            'image': null,
            'answer': surveyResult.answers[1].answer,
            'percent': '60',
            'isCurrentAnswer': 'false'
          }
        ]
      };

      await sut.save(surveyResult: surveyResult);

      verify(() => cacheStorage.save(
            key: 'survey_result/${surveyResult.surveyId}',
            value: json,
          )).called(1);
    });

    test('Should throw UnexpectedError if save throws', () async {
      cacheStorage.mockSaveError();

      final future = sut.save(surveyResult: surveyResult);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}
