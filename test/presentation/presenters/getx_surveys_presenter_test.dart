import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../../mocks/mocks.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  GetxSurveysPresenter sut;
  LoadSurveysSpy loadSurveys;
  List<SurveyEntity> surveys;

  PostExpectation mockLoadSurveysCall() => when(loadSurveys.load());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() =>
      mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  void mockAccessDeniedError() =>
      mockLoadSurveysCall().thenThrow(DomainError.accessDenied);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(FakeSurveysFactory.makeEntities());
  });

  test('should call loadSurveys on loadData', () async {
    await sut.loadData();

    verify(loadSurveys.load()).called(1);
  });

  test('should emits correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(
      (surveys) => expect(surveys, [
        SurveyViewModel(
          id: surveys[0].id,
          question: surveys[0].question,
          date: '02 Feb 2020',
          didAnswer: surveys[0].didAnswer,
        ),
        SurveyViewModel(
          id: surveys[1].id,
          question: surveys[1].question,
          date: '20 Dec 2018',
          didAnswer: surveys[1].didAnswer,
        ),
      ]),
    );

    await sut.loadData();
  });

  test('should emits correct events on failure', () async {
    mockLoadSurveysError();
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    sut.surveysStream.listen(null,
        onError: expectAsync1(
          (error) => expect(error, UIError.unexpected.description),
        ));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    sut.navigateToStream.listen(
      expectAsync1((page) => expect(page, '/survey_result/any_route_id')),
    );

    sut.goToSurveyResult('any_route_id');
  });

  test('Should emit correct events on access denied', () async {
    mockAccessDeniedError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    expectLater(sut.isSessionExpiredStream, emits(true));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey click', () async {
    expectLater(
        sut.navigateToStream,
        emitsInOrder([
          '/survey_result/any_route_id',
          '/survey_result/any_route_id',
        ]));

    sut.goToSurveyResult('any_route_id');
    sut.goToSurveyResult('any_route_id');
  });
}
