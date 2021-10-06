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
    if (tasting.characteristics == null || tasting.characteristics.isEmpty) {
      return Text('No tasting notes selected.');
    }

    return WineCriteriaBarChart(
      children: tasting.characteristics
          .where((c) => c.value != null)
          .map((c) => WineCriteriaBarChartData(criteriaLabel: c.name, intensity: c.value))
          .toList(),
    );
  }
}
