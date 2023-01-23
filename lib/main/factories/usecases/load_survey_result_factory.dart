import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../../composites/composites.dart';
import '../factories.dart';

LoadSurveyResult makeRemoteLoadSurveyResult(String surveyId) =>
    RemoteLoadSurveyResult(
      httpClient: makeAuthorizedHttpClientDecorator(),
      url: makeApiUrl('surveys/$surveyId/results'),
    );

LoadSurveyResult makeLocalLoadSurveyResult(String surveyId) =>
    LocalLoadSurveyResult(
      cacheStorage: makeLocalStorageAdapter(),
    );

LoadSurveyResult makeRemoteLoadSurveyResultWithLocalFallback(String surveyId) =>
    RemoteLoadSurveyResultWithLocalFallback(
      local: makeLocalLoadSurveyResult(surveyId),
      remote: makeRemoteLoadSurveyResult(surveyId),
    );
