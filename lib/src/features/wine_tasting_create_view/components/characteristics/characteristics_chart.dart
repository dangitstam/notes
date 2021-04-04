import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/common/widgets/criteria_bar_chart.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';

class CharacteristicsChart extends StatelessWidget {
  @required
  final WineTasting tasting;

  CharacteristicsChart({this.tasting});

  @override
  Widget build(BuildContext context) {
    return CriteriaBarChart(
      children: [
        CriteriaBarChartData(
          criteriaLabel: 'Acidity',
          intensity: tasting.acidity,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Sweetness',
          intensity: tasting.sweetness,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Tannin',
          intensity: tasting.tannin,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Body',
          intensity: tasting.body,
        ),
      ],
    );
  }
}
