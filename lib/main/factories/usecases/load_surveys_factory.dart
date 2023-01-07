import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

LoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
    url: makeApiUrl('surveys'),
    httpClient: makeHttpAdapter(),
  );
}
