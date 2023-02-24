import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {
  When mockLoadSurveyResultCall() =>
      when(() => this.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity surveyResult) =>
      this.mockLoadSurveyResultCall().thenAnswer((_) async => surveyResult);

  void mockLoadSurveyResultError(DomainError error) =>
      this.mockLoadSurveyResultCall().thenThrow(error);
}
