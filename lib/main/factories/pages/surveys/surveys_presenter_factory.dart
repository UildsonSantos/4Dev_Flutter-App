import '../../../../presentation/presenters/presenters.dart';
import '../../../../ui/pages/pages.dart';
import '../../usecases/usecases.dart';

SurveysPresenter makeGetxSurveysPresenter() =>
    GetxSurveysPresenter(loadSurveys: makeRemoteLoadSurveys());
