import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../common/util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class OverallWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.tasting.flavorScore;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 20),
                  Text('Overall', style: heading_6),
                  SizedBox(width: 20),
                  Text('Score: $score', style: caption, textAlign: TextAlign.right),
                  Expanded(
                    flex: 1,
                    child: BlackSliderTheme(
                      Slider(
                        value: score,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          context.read<CoffeeTastingCreateBloc>().add(FlavorScoreEvent(flavorScore: round(value)));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
