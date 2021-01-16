import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/styles/typography.dart';

import '../../util.dart';
import '../bloc/coffee_tasting_create_bloc.dart';
import 'criteria_util.dart';

class FragranceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var score = context.watch<CoffeeTastingCreateBloc>().state.fragranceScore;
    var fragranceBreak = context.watch<CoffeeTastingCreateBloc>().state.fragranceBreak;
    var fragranceDry = context.watch<CoffeeTastingCreateBloc>().state.fragranceDry;
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(builder: (context, state) {
      return Container(
        height: 225,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Fragrance', style: heading_6()),
            SizedBox(width: 20),
            Text('Score: $score', style: caption(), textAlign: TextAlign.right),
            Column(
              children: [
                Text('10', style: caption(fontWeight: FontWeight.bold)),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: BlackSliderTheme(
                      Slider(
                        value: score,
                        min: 6,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          context
                              .read<CoffeeTastingCreateBloc>()
                              .add(FragranceScoreEvent(fragranceScore: round(value)));
                        },
                      ),
                    ),
                  ),
                ),
                Text('0', style: caption(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(width: 20),
            Text('Intensity', style: caption(), textAlign: TextAlign.right),
            Column(
              children: [
                Icon(CupertinoIcons.plus_circle),
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: BlackSliderTheme(
                      Slider(
                        value: fragranceBreak,
                        min: 6,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          context
                              .read<CoffeeTastingCreateBloc>()
                              .add(FragranceBreakEvent(fragranceBreak: round(value)));
                        },
                      ),
                    ),
                  ),
                ),
                Icon(CupertinoIcons.minus_circle),
              ],
            ),
            // Text('Dry', style: caption(), textAlign: TextAlign.right),
            // Expanded(
            //   flex: 0,
            //   child: Column(
            //     children: [
            //       Text('High', style: caption()),
            //       Expanded(
            //         child: RotatedBox(
            //           quarterTurns: 3,
            //           child: BlackSliderTheme(
            //             Slider(
            //               value: fragranceDry,
            //               min: 6,
            //               max: 10,
            //               divisions: 10,
            //               onChanged: (value) {
            //                 context.read<CoffeeTastingCreateBloc>().add(FragranceDryEvent(fragranceDry: value));
            //               },
            //             ),
            //           ),
            //         ),
            //       ),
            //       Text('Low', style: caption()),
            //     ],
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
