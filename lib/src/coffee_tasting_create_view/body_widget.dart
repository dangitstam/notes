import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../util.dart';
import 'bloc/coffee_tasting_create_bloc.dart';

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.bodyScore;
    var level = context.watch<CoffeeTastingCreateBloc>().state.bodyLevel;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Column(
        children: [
          Text('Body', style: subtitle_1()),
          Container(
            height: 140,
            child: Row(
              children: [
                SizedBox(width: 20),
                Text('Score: $score', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 1,
                  child: blackSliderTheme(
                    Slider(
                      value: score,
                      min: 6,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        context.read<CoffeeTastingCreateBloc>().add(BodyScoreEvent(bodyScore: value));
                      },
                    ),
                  ),
                ),
                Text('Level', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('Heavy', style: caption()),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: blackSliderTheme(
                            Slider(
                              value: level,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) {
                                context
                                    .read<CoffeeTastingCreateBloc>()
                                    .add(BodyLevelEvent(bodyLevel: value));
                              },
                            ),
                          ),
                        ),
                      ),
                      Text('Thin', style: caption()),
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
