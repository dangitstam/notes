import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';

class AftertasteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.aftertasteScore;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return Column(
          children: [
            Text('Aftertaste', style: subtitle_1()),
            Container(
              height: 100,
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
                          context.watch<CoffeeTastingCreateBloc>().add(AftertasteScoreEvent(aftertasteScore: value));
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
