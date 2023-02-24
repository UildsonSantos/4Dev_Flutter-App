import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveyResultPresenterSpy extends Mock implements SurveyResultPresenter {
  final surveyResultController = StreamController<SurveyResultViewModel?>();
  final isSessionExpiredController = StreamController<bool>();
  final isLoadingController = StreamController<bool>();

  SurveyResultPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);
    when(() => this.save(answer: any(named: 'answer')))
        .thenAnswer((_) async => _);

    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);

    when(() => this.surveyResultStream)
        .thenAnswer((_) => surveyResultController.stream);
  }

  void emitSurveyResultValid(SurveyResultViewModel? data) =>
      surveyResultController.add(data);
  void emitSurveyResultError(String uiError) =>
      surveyResultController.addError(uiError);

  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitSessionExpired([bool show = true]) =>
      isSessionExpiredController.add(show);

  void dispose() {
    surveyResultController.close();
    isLoadingController.close();
    isSessionExpiredController.close();
  }
}
