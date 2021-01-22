import 'package:flutter/material.dart';

import 'criteria_caption.dart';
import 'criteria_linear_indicator.dart';

class CriteriaBarChartData {
  CriteriaBarChartData({
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

class CriteriaBarChart extends StatelessWidget {
  CriteriaBarChart({this.children});

  final List<CriteriaBarChartData> children;

  @override
  Widget build(BuildContext context) {
    var linearIndicators = <CriteriaLinearIndicator>[];
    for (var datum in children) {
      linearIndicators.add(
        CriteriaLinearIndicator(
          datum.score,
          datum.scoreLabel,
          datum.scoreColor,
        ),
      );
      linearIndicators.add(
        CriteriaLinearIndicator(
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
            children: children.map((e) => CriteriaCaption(e.criteriaLabel)).toList(),
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
