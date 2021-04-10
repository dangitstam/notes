import 'package:flutter/material.dart';
import 'package:notes/src/common/widgets/coffee/coffee_criteria_linear_indicator.dart';

class CoffeeCriteriaBarChartData {
  CoffeeCriteriaBarChartData({
    this.criteriaLabel,
    this.score,
    this.scoreLabel,
    this.scoreColor,
    this.intensity,
    this.intensityLabel,
    this.intensityColor,
  });

  String criteriaLabel;

  double score;
  String scoreLabel;
  Color scoreColor;

  double intensity;
  String intensityLabel;
  Color intensityColor;
}

class CoffeeCriteriaBarChart extends StatelessWidget {
  CoffeeCriteriaBarChart({this.children});

  final List<CoffeeCriteriaBarChartData> children;

  @override
  Widget build(BuildContext context) {
    var linearIndicators = <CoffeeCriteriaLinearIndicator>[];
    for (var datum in children) {
      linearIndicators.add(
        CoffeeCriteriaLinearIndicator(
          datum.score,
          datum.scoreLabel,
          datum.scoreColor,
        ),
      );
      linearIndicators.add(
        CoffeeCriteriaLinearIndicator(
          datum.intensity,
          datum.intensityLabel,
          datum.intensityColor,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children.map((e) => CoffeeCriteriaCaption(e.criteriaLabel)).toList(),
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: linearIndicators,
          ),
        )
      ],
    );
  }
}

class CoffeeCriteriaCaption extends StatelessWidget {
  CoffeeCriteriaCaption(this.criteria);

  final String criteria;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Center(
        child: Text(
          '$criteria',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
