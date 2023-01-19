import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import 'components/components.dart';
import 'survey_result.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  SurveyResultPage({@required this.presenter});
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
      body: Builder(
        builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            isLoading == true ? showLoading(context) : hideLoading(context);
          });

           presenter.isSessionExpiredStream.listen((isExpired) {
            if (isExpired == true) {
              Get.offAllNamed('/login');
            }
          });
          
          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                      error: snapshot.error, reload: presenter.loadData);
                }
                if (snapshot.hasData) {
                  return SurveyResult(viewModel: snapshot.data);
                }
                return SizedBox(height: 0);
              });
        },
      ),
    );
  }
}
