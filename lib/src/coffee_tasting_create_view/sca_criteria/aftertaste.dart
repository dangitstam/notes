import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class AftertasteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.aftertasteScore;
    var level = 7.0;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              height: 225,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Aftertaste', style: heading_6()),
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
                                  context
                                      .read<CoffeeTastingCreateBloc>()
                                      .add(AftertasteScoreEvent(aftertasteScore: round(value)));
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
                  Text('Duration', style: caption(), textAlign: TextAlign.right),
                  Expanded(
                    flex: 0,
                    child: Column(
                      children: [
                        Text('Long', style: caption(fontWeight: FontWeight.bold)),
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
                                  // TODO: Add duration to coffee tasting data model.
                                  level = value;
                                },
                              ),
                            ),
                          ),
                        ),
                        Text('Short', style: caption(fontWeight: FontWeight.bold)),
                      ],
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
