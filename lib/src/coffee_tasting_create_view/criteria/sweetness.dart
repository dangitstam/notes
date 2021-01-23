import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class SweetnessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.tasting.sweetnessScore;
    var intensity = context.watch<CoffeeTastingCreateBloc>().state.tasting.sweetnessIntensity;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Container(
        height: 225,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sweetness', style: Theme.of(context).textTheme.headline6),
            SizedBox(width: 10),
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
                          context
                              .read<CoffeeTastingCreateBloc>()
                              .add(SweetnessScoreEvent(sweetnessScore: round(value)));
                        },
                      ),
                    ),
                  ),
                ),
                Text(
                  '0',
                  style:
                      Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold).copyWith(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(width: 10),
            Text('Intensity', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right),
            Column(
              children: [
                Icon(CupertinoIcons.plus_circle),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: BlackSliderTheme(
                      Slider(
                        value: intensity,
                        min: 0,
                        max: 10,
                        onChanged: (value) {
                          context
                              .read<CoffeeTastingCreateBloc>()
                              .add(SweetnessIntensityEvent(sweetnessIntensity: round(value)));
                        },
                      ),
                    ),
                  ),
                ),
                Icon(CupertinoIcons.minus_circle),
              ],
            ),
          ],
        ),
      );
    });
  }
}
