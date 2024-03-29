import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';

import '../bloc/coffee_tasting_create_bloc.dart';

class FlavorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.tasting.flavorScore;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return Container(
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(width: 20),
              Text('Flavor', style: Theme.of(context).textTheme.headline6),
              SizedBox(width: 20),
              Text('Score: $score', style: Theme.of(context).textTheme.caption, textAlign: TextAlign.right),
              Expanded(
                flex: 1,
                child: ThemedPaddedSlider(
                  child: Slider(
                    value: score,
                    min: 0,
                    max: 10,
                    onChanged: (value) {
                      context.read<CoffeeTastingCreateBloc>().add(FlavorScoreEvent(flavorScore: round(value)));
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
