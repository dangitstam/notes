import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/common/widgets/criteria_bar_chart.dart';

class CharacteristicsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var coffeeTastingState = context.watch<CoffeeTastingCreateBloc>().state.tasting;

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 10.0),
      child: CriteriaBarChart(children: [
        CriteriaBarChartData(
          criteriaLabel: 'Aroma',
          score: coffeeTastingState.aromaScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: coffeeTastingState.aromaIntensity,
          intensityLabel: 'Intensity',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Acidity',
          score: coffeeTastingState.acidityScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: coffeeTastingState.acidityIntensity,
          intensityLabel: 'Intensity',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Body',
          score: coffeeTastingState.bodyScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: coffeeTastingState.bodyLevel,
          intensityLabel: 'Level',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Sweetness',
          score: coffeeTastingState.sweetnessScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: coffeeTastingState.sweetnessIntensity,
          intensityLabel: 'Intensity',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
        CriteriaBarChartData(
          criteriaLabel: 'Finish',
          score: coffeeTastingState.finishScore,
          scoreLabel: 'Score',
          scoreColor: Theme.of(context).colorScheme.onSurface,
          intensity: coffeeTastingState.finishDuration,
          intensityLabel: 'Duration',
          intensityColor: Theme.of(context).colorScheme.primary,
        ),
      ]),
    );
  }
}
