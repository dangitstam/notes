import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';

class FragranceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.fragranceScore;
    var fragranceBreak = context.watch<CoffeeTastingCreateBloc>().state.fragranceBreak;
    var fragranceDry = context.watch<CoffeeTastingCreateBloc>().state.fragranceDry;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Column(
        children: [
          Text('Fragrance', style: subtitle_1()),
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
                        context.watch<CoffeeTastingCreateBloc>().add(FragranceScoreEvent(fragranceScore: value));
                      },
                    ),
                  ),
                ),
                Text('Break', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('High', style: caption()),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: blackSliderTheme(
                            Slider(
                              value: fragranceBreak,
                              min: 6,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) {
                                context
                                    .watch<CoffeeTastingCreateBloc>()
                                    .add(FragranceBreakEvent(fragranceBreak: value));
                              },
                            ),
                          ),
                        ),
                      ),
                      Text('Low', style: caption()),
                    ],
                  ),
                ),
                Text('Dry', style: caption(), textAlign: TextAlign.right),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Text('High', style: caption()),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: blackSliderTheme(
                            Slider(
                              value: fragranceDry,
                              min: 6,
                              max: 10,
                              divisions: 10,
                              onChanged: (value) {
                                context.watch<CoffeeTastingCreateBloc>().add(FragranceDryEvent(fragranceDry: value));
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
