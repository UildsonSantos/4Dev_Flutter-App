import 'dart:async';

import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {
  final isLoadingController = StreamController<bool>();
  final isSessionExpiredController = StreamController<bool>();
  final surveysController = StreamController<List<SurveyViewModel>>();
  final navigateToController = StreamController<String>();

  SurveysPresenterSpy() {
    when(() => this.loadData()).thenAnswer((_) async => _);

    when(() => this.goToSurveyResult(any())).thenAnswer((_) async => _);

    when(() => this.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(() => this.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);

    when(() => this.surveysStream).thenAnswer((_) => surveysController.stream);

    when(() => this.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void emiSurveyValid(List<SurveyViewModel> surveys) =>
      surveysController.add(surveys);

  void emitSessionExpired([bool show = true]) =>
      isSessionExpiredController.add(show);

  void emitSurveyError(String uiError) => surveysController.addError(uiError);
  void emitLoading([bool show = true]) => isLoadingController.add(show);
  void emitNavigateTo(String route) => navigateToController.add(route);

  void dispose() {
    isLoadingController.close();
    isSessionExpiredController.close();
    surveysController.close();
    navigateToController.close();
  }
}
