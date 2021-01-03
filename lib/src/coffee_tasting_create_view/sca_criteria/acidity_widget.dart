import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';

class AcidityWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.acidityScore;
    var intensity = context.watch<CoffeeTastingCreateBloc>().state.acidityIntensity;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Column(
        children: [
          Text('Acidity', style: subtitle_1()),
          Container(
            height: 140,
            child: Row(
              children: [
                SizedBox(width: 20),
                Text('Score: $score', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 1,
                  child: BlackSliderTheme(
                    Slider(
                      value: score,
                      min: 6,
                      max: 10,
                      divisions: 10,
                      onChanged: (value) {
                        context.read<CoffeeTastingCreateBloc>().add(AcidityScoreEvent(acidityScore: value));
                      },
                    ),
                  ),
                ),
                Text('Intensity', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('High', style: caption()),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: BlackSliderTheme(
                            Slider(
                              value: intensity,
                              min: 6,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) {
                                context
                                    .read<CoffeeTastingCreateBloc>()
                                    .add(AcidityIntensityEvent(acidityIntensity: value));
                              },
                            ),
                          ),
                        ),
                      ),
                      Text('Low', style: caption()),
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
