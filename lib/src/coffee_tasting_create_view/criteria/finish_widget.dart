import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class FinishWidget extends StatelessWidget {
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
              Text('Finish', style: Theme.of(context).textTheme.headline6),
              SizedBox(width: 20),
              Text('Score', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right),
              Column(
                children: [
                  Text('10',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontWeight: FontWeight.bold)
                          .copyWith(fontSize: 14)),
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
                  Text('0',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontWeight: FontWeight.bold)
                          .copyWith(fontSize: 14)),
                ],
              ),
              SizedBox(width: 20),
              Text('Duration', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right),
              Column(
                children: [
                  Text('Long', style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: BlackSliderTheme(
                        Slider(
                          value: duration,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            context
                                .read<CoffeeTastingCreateBloc>()
                                .add(FinishDurationEvent(finishDuration: round(value)));
                          },
                        ),
                      ),
                    ),
                  ),
                  Text('Short', style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}