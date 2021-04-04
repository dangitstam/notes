import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

class CharacteristicsChart extends StatelessWidget {
  @required
  final CoffeeTasting tasting;

  CharacteristicsChart({this.tasting});

  @override
  Widget build(BuildContext context) {
    // TODO: Coffee should be its own app.
    return Container();
    // return Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 10.0),
    //   child: CriteriaBarChart(children: [
    //     CriteriaBarChartData(
    //       criteriaLabel: 'Aroma',
    //       score: tasting.aromaScore,
    //       scoreLabel: 'Score',
    //       scoreColor: Theme.of(context).colorScheme.onSurface,
    //       intensity: tasting.aromaIntensity,
    //       intensityLabel: 'Intensity',
    //       intensityColor: Theme.of(context).colorScheme.primary,
    //     ),
    //     CriteriaBarChartData(
    //       criteriaLabel: 'Acidity',
    //       score: tasting.acidityScore,
    //       scoreLabel: 'Score',
    //       scoreColor: Theme.of(context).colorScheme.onSurface,
    //       intensity: tasting.acidityIntensity,
    //       intensityLabel: 'Intensity',
    //       intensityColor: Theme.of(context).colorScheme.primary,
    //     ),
    //     CriteriaBarChartData(
    //       criteriaLabel: 'Body',
    //       score: tasting.bodyScore,
    //       scoreLabel: 'Score',
    //       scoreColor: Theme.of(context).colorScheme.onSurface,
    //       intensity: tasting.bodyLevel,
    //       intensityLabel: 'Level',
    //       intensityColor: Theme.of(context).colorScheme.primary,
    //     ),
    //     CriteriaBarChartData(
    //       criteriaLabel: 'Sweetness',
    //       score: tasting.sweetnessScore,
    //       scoreLabel: 'Score',
    //       scoreColor: Theme.of(context).colorScheme.onSurface,
    //       intensity: tasting.sweetnessIntensity,
    //       intensityLabel: 'Intensity',
    //       intensityColor: Theme.of(context).colorScheme.primary,
    //     ),
    //     CriteriaBarChartData(
    //       criteriaLabel: 'Finish',
    //       score: tasting.finishScore,
    //       scoreLabel: 'Score',
    //       scoreColor: Theme.of(context).colorScheme.onSurface,
    //       intensity: tasting.finishDuration,
    //       intensityLabel: 'Duration',
    //       intensityColor: Theme.of(context).colorScheme.primary,
    //     ),
    //   ]),
    // );
  }
}
