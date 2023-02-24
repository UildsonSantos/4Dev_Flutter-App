import 'package:fordev/domain/usecases/usecases.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {
  When mockLoadSurveysCall() => when(() => this.load());

  void mockLoadSurveys(List<SurveyEntity> surveys) =>
      this.mockLoadSurveysCall().thenAnswer((_) async => surveys);

  void mockLoadSurveysError(DomainError error) =>
      this.mockLoadSurveysCall().thenThrow(error);
}
