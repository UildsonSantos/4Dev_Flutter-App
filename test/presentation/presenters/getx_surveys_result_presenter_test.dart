import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}

void main() {
  GetxSurveyResultPresenter sut;
  LoadSurveyResultSpy loadSurveyResult;
  SurveyResultEntity surveyResult;
  String surveyId;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
          surveyId: faker.guid.guid(),
          question: faker.lorem.sentence(),
          answers: [
            SurveyAnswerEntity(
              image: faker.internet.httpUrl(),
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean(),
            ),
            SurveyAnswerEntity(
              answer: faker.lorem.sentence(),
              percent: faker.randomGenerator.integer(100),
              isCurrentAnswer: faker.randomGenerator.boolean(),
            )
          ]);

  PostExpectation mockLoadSurveyResultCall() =>
      when(loadSurveyResult.loadBySurvey(surveyId: anyNamed('surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    surveyResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);
  }

  void mockLoadSurveyResultError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveyResultCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    surveyId = faker.guid.guid();
    loadSurveyResult = LoadSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      surveyId: surveyId,
    );
    mockLoadSurveyResult(mockValidData());
  });

  test('should call loadSurveyResult on loadData', () async {
    await sut.loadData();

    verify(loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
  });

  test('should emits correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveyResultStream.listen(
      expectAsync1(
        (result) => expect(
          result,
          SurveyResultViewModel(
            surveyId: surveyResult.surveyId,
            question: surveyResult.question,
            answers: [
              SurveyAnswerViewModel(
                  image: surveyResult.answers[0].image,
                  answer: surveyResult.answers[0].answer,
                  isCurrentAnswer: surveyResult.answers[0].isCurrentAnswer,
                  percent: '${surveyResult.answers[0].percent}%'),
              SurveyAnswerViewModel(
                  answer: surveyResult.answers[1].answer,
                  isCurrentAnswer: surveyResult.answers[1].isCurrentAnswer,
                  percent: '${surveyResult.answers[1].percent}%')
            ],
          ),
        ),
      ),
    );

    await sut.loadData();
  });

  test('should emits correct events on failure', () async {
    mockLoadSurveyResultError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveyResultStream.listen(null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ));

    await sut.loadData();
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });
}