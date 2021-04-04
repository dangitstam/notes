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
          score: tasting.acidityScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: tasting.acidityIntensity,
          intensityLabel: 'Intensity',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Sweetness',
          score: tasting.sweetnessScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: tasting.sweetnessIntensity,
          intensityLabel: 'Intensity',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Astringency',
          score: tasting.finishScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: tasting.finishDuration,
          intensityLabel: 'Duration',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Body',
          score: tasting.bodyScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: tasting.bodyLevel,
          intensityLabel: 'Level',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
