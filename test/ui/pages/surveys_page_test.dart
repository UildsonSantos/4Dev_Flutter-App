import 'package:flutter_test/flutter_test.dart';
import 'package:get/route_manager.dart';
import 'package:mockito/mockito.dart';

import 'package:fordev/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  testWidgets('should call loadSurveys on page load',
      (WidgetTester tester) async {

    final presenter = SurveysPresenterSpy();

    final surveysPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [GetPage(name: '/surveys', page: () => SurveysPage(presenter: presenter))],
    );

    await tester.pumpWidget(surveysPage);

    verify(presenter.loadData()).called(1);
  });
}
