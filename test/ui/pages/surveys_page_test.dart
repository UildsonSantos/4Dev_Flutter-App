import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenterSpy presenter;
  StreamController<bool> isLoadingController;
  StreamController<bool> isSessionExpiredController;
  StreamController<List<SurveyViewModel>> loadSurveysController;
  StreamController<String> navigateToController;

  void initStreams() {
    isLoadingController = StreamController<bool>();
    isSessionExpiredController = StreamController<bool>();
    loadSurveysController = StreamController<List<SurveyViewModel>>();
    navigateToController = StreamController<String>();
  }

  void mockStreams() {
    when(presenter.isLoadingStream)
        .thenAnswer((_) => isLoadingController.stream);

    when(presenter.isSessionExpiredStream)
        .thenAnswer((_) => isSessionExpiredController.stream);

    when(presenter.surveysStream)
        .thenAnswer((_) => loadSurveysController.stream);

    when(presenter.navigateToStream)
        .thenAnswer((_) => navigateToController.stream);
  }

  void closeStreams() {
    isLoadingController.close();
    isSessionExpiredController.close();
    loadSurveysController.close();
    navigateToController.close();
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();
    initStreams();
    mockStreams();
    final routeObserver = Get.put<RouteObserver>(RouteObserver<PageRoute>());
    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      navigatorObservers: [routeObserver],
      getPages: [
        GetPage(
            name: '/surveys', page: () => SurveysPage(presenter: presenter)),
        GetPage(
          name: '/any_route',
          page: () => Scaffold(
            appBar: AppBar(
              title: Text('any_title'),
            ),
            body: Text('fake page'),
          ),
        ),
        GetPage(name: '/login', page: () => Scaffold(body: Text('fake login'))),
      ],
    );

    await tester.pumpWidget(surveysPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
          id: '1',
          question: 'Question 1',
          date: 'Date 1',
          didAnswer: true,
        ),
        SurveyViewModel(
          id: '2',
          question: 'Question 2',
          date: 'Date 2',
          didAnswer: false,
        ),
      ];

  tearDown(() {
    closeStreams();
  });

  testWidgets('should call loadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.loadData()).called(1);
  });

  testWidgets('should call loadSurveys on page reload',
      (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoadingController.add(true);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoadingController.add(null);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(
      find.text('Algo inesperado aconteceu! Tente novamente mais tarde.'),
      findsOneWidget,
    );
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('should present list if loadSurveysStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    expect(
      find.text('Algo inesperado aconteceu! Tente novamente mais tarde.'),
      findsNothing,
    );
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsWidgets);
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text('Date 1'), findsWidgets);
    expect(find.text('Date 2'), findsWidgets);
  });

  testWidgets('should call loadSurveys on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click',
      (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.add(makeSurveys());
    await tester.pump();

    final anyElement = find.text('Question 1');
    await tester.tap(anyElement);
    await tester.pump();

    verify(presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('/any_route');
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');

    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.add('');
    await tester.pump();

    expect(Get.currentRoute, '/surveys');

    navigateToController.add(null);
    await tester.pump();

    expect(Get.currentRoute, '/surveys');
  });

  testWidgets('should logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(true);
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/login');

    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    isSessionExpiredController.add(false);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/surveys');

    isSessionExpiredController.add(null);
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/surveys');
  });
}
