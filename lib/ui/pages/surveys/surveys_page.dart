import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  SurveysPage({@required this.presenter});

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.subscribe(this, ModalRoute.of(context));

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
        handleLoading(context, widget.presenter.isLoadingStream);
        handleSessionExpired(widget.presenter.isSessionExpiredStream);
        handleNavigation(widget.presenter.navigateToStream);

        widget.presenter.loadData();

        return StreamBuilder<List<SurveyViewModel>>(
          stream: widget.presenter.surveysStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReloadScreen(
                error: snapshot.error,
                reload: widget.presenter.loadData,
              );
            }
            if (snapshot.hasData) {
              return Provider(
                create: (_) => widget.presenter,
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

  @override
  void didPopNext() {
    widget.presenter.loadData();
  }

  @override
  void dispose() {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
