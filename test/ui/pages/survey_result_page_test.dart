import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:fordev/ui/helpers/helpers.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:fordev/ui/pages/survey_result/components/components.dart';

import '../helpers/helpers.dart';
import '../mocks/mocks.dart';

void main() {
  late SurveyResultPresenterSpy presenter;

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SurveyResultPresenterSpy();

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(makePage(
          path: '/survey_result/any_survey_id',
          page: () => SurveyResultPage(presenter: presenter)));
    });
  }

  tearDown(() {
    presenter.dispose();
  });

  testWidgets('should call loadSurveyResult on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(() => presenter.loadData()).called(1);
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

  testWidgets('should present error if SurveyResultStream fails',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();

    expect(
      find.text('Algo inesperado aconteceu! Tente novamente mais tarde.'),
      findsOneWidget,
    );
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question'), findsNothing);
  });

  testWidgets('should call loadSurveyResult on reload button click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultError(UIError.unexpected.description);
    await tester.pump();

    await tester.tap(find.text('Recarregar'));

    verify(() => presenter.loadData()).called(2);
  });

  testWidgets('should present valid data if surveyResultStream succeeds',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultValid(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });

    expect(
      find.text('Algo inesperado aconteceu! Tente novamente mais tarde.'),
      findsNothing,
    );
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question'), findsOneWidget);
    expect(find.text('Answer 0'), findsOneWidget);
    expect(find.text('Answer 1'), findsOneWidget);
    expect(find.text('60%'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);
    expect(find.byType(ActiveIcon), findsOneWidget);
    expect(find.byType(DisabledIcon), findsOneWidget);
    final image =
        tester.widget<Image>(find.byType(Image)).image as NetworkImage;
    expect(image.url, 'Image 0');
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
    expect(currentRoute, '/survey_result/any_survey_id');
  });

  testWidgets('should call save on list item click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultValid(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 1'));

    verify(() => presenter.save(answer: 'Answer 1')).called(1);
  });

  testWidgets('should not call save on current answer click',
      (WidgetTester tester) async {
    await loadPage(tester);

    presenter.emitSurveyResultValid(ViewModelFactory.makeSurveyResult());
    await mockNetworkImagesFor(() async {
      await tester.pump();
    });
    await tester.tap(find.text('Answer 0'));

    verifyNever(() => presenter.save(answer: 'Answer 0'));
  });
}
