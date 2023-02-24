import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';


void main() {
  late SurveysPresenterSpy presenter;
  

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveysPresenterSpy();

    await tester.pumpWidget(makePage(
        path: '/surveys', page: () => SurveysPage(presenter: presenter)));
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('should call loadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
  });

  testWidgets('should call loadSurveys on page reload',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();
    await tester.pageBack();

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should handle loading correctly', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    presenter.emitLoading(false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    presenter.emitLoading();
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('should present error if loadSurveysStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyError(UIError.unexpected.description);
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

    presenter.emiSurveyValid(ViewModelFactory.makeSurveyList());
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

    presenter.emitSurveyError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should call goToSurveyResult on survey click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emiSurveyValid(ViewModelFactory.makeSurveyList());
    await tester.pump();

    final anyElement = find.text('Question 1');
    await tester.tap(anyElement);
    await tester.pump();

    verify(() => presenter.goToSurveyResult('1')).called(1);
  });

  testWidgets('should change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('/any_route');
    await tester.pumpAndSettle();

    expect(currentRoute, '/any_route');

    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('should not change page', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitNavigateTo('');
    await tester.pump();

    expect(currentRoute, '/surveys');
  });

  testWidgets('should logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired();
    await tester.pumpAndSettle();

    expect(currentRoute, '/login');

    expect(find.text('fake login'), findsOneWidget);
  });

  testWidgets('should not logout', (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSessionExpired(false);
    await tester.pumpAndSettle();
    expect(currentRoute, '/surveys');
  });
}
