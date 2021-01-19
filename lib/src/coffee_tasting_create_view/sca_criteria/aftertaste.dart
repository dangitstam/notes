import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../common/util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class AftertasteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.tasting.finishScore;
    var duration = context.watch<CoffeeTastingCreateBloc>().state.tasting.finishDuration;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return Container(
          height: 225,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Finish', style: heading_6()),
              SizedBox(width: 20),
              Text('Score', style: caption(), textAlign: TextAlign.right),
              Column(
                children: [
                  Text('10', style: caption(fontWeight: FontWeight.bold).copyWith(fontSize: 14)),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: BlackSliderTheme(
                        Slider(
                          value: score,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            context.read<CoffeeTastingCreateBloc>().add(FinishScoreEvent(finishScore: round(value)));
                          },
                        ),
                      ),
                    ),
                  ),
                  Text('0', style: caption(fontWeight: FontWeight.bold).copyWith(fontSize: 14)),
                ],
              ),
              SizedBox(width: 20),
              Text('Duration', style: caption(), textAlign: TextAlign.right),
              Column(
                children: [
                  Text('Long', style: caption(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: BlackSliderTheme(
                        Slider(
                          value: duration,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            // TODO: Add duration to coffee tasting data model.
                            context
                                .read<CoffeeTastingCreateBloc>()
                                .add(FinishDurationEvent(finishDuration: round(value)));
                          },
                        ),
                      ),
                    ),
                  ),
                  Text('Short', style: caption(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
