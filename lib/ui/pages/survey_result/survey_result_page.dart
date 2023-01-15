import 'package:flutter/material.dart';

import '../../helpers/helpers.dart';

class SurveyResultPage extends StatelessWidget {
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
      body: Center(child: Text('SurveyResultPage working')),
    );
  }
}
