import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

SaveSurveyResult makeRemoteSaveSurveyResult(String surveyId) =>
    RemoteSaveSurveyResult(
      httpClient: makeAuthorizedHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );
