import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RoastLevelLinearIndicator extends StatelessWidget {
  RoastLevelLinearIndicator(this.percentage);

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Roast Level', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.left),
        SizedBox(width: 5),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.onSurface,
              value: percentage,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
              minHeight: 14,
            ),
          ),
        )
      ],
    );
  }
}
