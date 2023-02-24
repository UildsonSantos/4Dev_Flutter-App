import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../pages.dart';
import '../surveys.dart';
import 'components.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModel;

  const SurveyItems({
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
        ),
        items: viewModel
            .map((viewModel) => SurveyItem(viewModel: viewModel))
            .toList(),
      ),
    );
  }
}
