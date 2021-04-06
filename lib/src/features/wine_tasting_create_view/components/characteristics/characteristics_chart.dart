import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/common/widgets/wine/wine_criteria_bar_chart.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';

class CharacteristicsChart extends StatelessWidget {
  @required
  final WineTasting tasting;

  CharacteristicsChart({this.tasting});

  @override
  Widget build(BuildContext context) {
    return WineCriteriaBarChart(
      children: [
        WineCriteriaBarChartData(
          criteriaLabel: 'Acidity',
          intensity: tasting.acidity,
        ),
        WineCriteriaBarChartData(
          criteriaLabel: 'Sweetness',
          intensity: tasting.sweetness,
        ),
        WineCriteriaBarChartData(
          criteriaLabel: 'Tannin',
          intensity: tasting.tannin,
        ),
        WineCriteriaBarChartData(
          criteriaLabel: 'Body',
          intensity: tasting.body,
        ),
      ],
    );
  }
}
