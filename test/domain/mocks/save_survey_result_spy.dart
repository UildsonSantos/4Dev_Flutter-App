import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {
  When mockSaveSurveyResultCall() =>
      when(() => this.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) =>
      this.mockSaveSurveyResultCall().thenAnswer((_) async => data);

  void mockSaveSurveyResultError(DomainError error) =>
      this.mockSaveSurveyResultCall().thenThrow(error);
}
