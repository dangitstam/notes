import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Given a slider, applies the black slider theme.
class ThemedPaddedSlider extends StatelessWidget {
  final Slider child;
  final EdgeInsets padding;

  ThemedPaddedSlider({
    this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 15.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SliderTheme(
        data: Theme.of(context).sliderTheme,
        child: child,
      ),
    );
  }
}
