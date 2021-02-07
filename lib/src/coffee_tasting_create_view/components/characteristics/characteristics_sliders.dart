import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';

/// Custom widget with a pair of sliders to modify two values.
///
/// Both [score] and [intensity] are expected to be watched BLoC values.
/// The two sliders call [udpateScore] and [updateIntensity] respectively. These
/// functions are assumed to modify [score] and [intensity], as the slider reads
/// these values directly. Otherwise, slider positions will not update properly.
///
/// [intensitySliderLabel], [intensityPositiveEndLabel], and [intensityNegativeEndLabel]
/// allow customization of the right slider.
class CharacteristicsSliders extends StatelessWidget {
  @required
  final String characteristic;
  @required
  final double score;
  @required
  final double intensity;

  final String intensitySliderLabel;
  final Widget intensityPositiveEndLabel;
  final Widget intensityNegativeEndLabel;

  @required
  final Function(double) updateScore;
  @required
  final Function(double) updateIntensity;

  CharacteristicsSliders({
    this.characteristic,
    this.score,
    this.intensity,
    this.updateScore,
    this.updateIntensity,
    this.intensitySliderLabel = 'Intensity',
    this.intensityPositiveEndLabel = const Icon(CupertinoIcons.plus_circle),
    this.intensityNegativeEndLabel = const Icon(CupertinoIcons.minus_circle),
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$characteristic'.toUpperCase(),
          style: Theme.of(context).textTheme.overline,
        ),
        SizedBox(width: 20),
        Text(
          'Score',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.right,
        ),
        Column(
          children: [
            Text(
              '10',
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
            ),
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: ThemedPaddedSlider(
                  child: Slider(
                    value: score,
                    min: 0,
                    max: 10,
                    onChanged: (value) {
                      updateScore(value);
                    },
                  ),
                ),
              ),
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        SizedBox(width: 20),
        Text(
          '$intensitySliderLabel',
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.right,
        ),
        Column(
          children: [
            intensityPositiveEndLabel,
            Expanded(
              child: RotatedBox(
                quarterTurns: 3,
                child: ThemedPaddedSlider(
                  child: Slider(
                    value: intensity,
                    min: 0,
                    max: 10,
                    onChanged: (value) {
                      updateIntensity(value);
                    },
                  ),
                ),
              ),
            ),
            intensityNegativeEndLabel,
          ],
        ),
      ],
    );
  }
}
