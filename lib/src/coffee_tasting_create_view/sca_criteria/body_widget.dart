import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.bodyScore;
    var level = context.watch<CoffeeTastingCreateBloc>().state.bodyLevel;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Column(
        children: [
          Container(
            height: 225,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Body', style: heading_6()),
                SizedBox(width: 20),
                Text('Score: $score', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('10', style: caption(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: BlackSliderTheme(
                            Slider(
                              value: score,
                              min: 0,
                              max: 10,
                              onChanged: (value) {
                                context.read<CoffeeTastingCreateBloc>().add(BodyScoreEvent(bodyScore: round(value)));
                              },
                            ),
                          ),
                        ),
                      ),
                      Text('0', style: caption(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Text('Level', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('Heavy', style: caption(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: BlackSliderTheme(
                            Slider(
                              value: level,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) {
                                context.read<CoffeeTastingCreateBloc>().add(BodyLevelEvent(bodyLevel: round(value)));
                              },
                            ),
                          ),
                        ),
                      ),
                      Text('Thin', style: caption(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
