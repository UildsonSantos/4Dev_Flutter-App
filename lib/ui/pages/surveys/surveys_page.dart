import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import '../pages.dart';
import 'components/components.dart';

class SurveysPage extends StatelessWidget {
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
        presenter.isLoadingStream.listen((isLoading) {
          isLoading == true ? showLoading(context) : hideLoading(context);
        });


        presenter.navigateToStream.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.toNamed(page);
          }
        });
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
