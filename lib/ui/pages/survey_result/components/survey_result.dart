import 'package:flutter/material.dart';

import '../survey_result.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;
  final void Function({required String answer}) onSave;

  const SurveyResult({
    required this.viewModel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(question: viewModel.question);
        }
        final answerItem = viewModel.answers[index - 1];
        return GestureDetector(
          onTap: () => answerItem.isCurrentAnswer
              ? null
              : onSave(answer: answerItem.answer),
          child: SurveyAnswer(viewModel: answerItem),
        );
      },
      itemCount: viewModel.answers.length + 1,
    );
  }
}
