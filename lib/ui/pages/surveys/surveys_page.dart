import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigationManager, SessionManager {
  final SurveysPresenter presenter;

  SurveysPage({@required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            R.strings.surveys,
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
      body: Builder(builder: (context) {
        handleLoading(context, presenter.isLoadingStream);
        handleSessionExpired(presenter.isSessionExpiredStream);
        handleNavigation(presenter.navigateToStream);

        presenter.loadData();

        return StreamBuilder<List<SurveyViewModel>>(
          stream: presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReloadScreen(
                error: snapshot.error,
                reload: presenter.loadData,
              );
            }
            if (snapshot.hasData) {
              return Provider(
                create: (_) => presenter,
                child: SurveyItems(
                  viewModel: snapshot.data,
                ),
              );
            }
            return SizedBox(height: 0);
          },
        );
      }),
    );
  }
}
