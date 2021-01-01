import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';

import 'package:notes/src/data/model/note.dart';

/// Given a tasting note, creates a widget containing the note name
/// filled with the note's color.
Widget displayNote(Note note) {
  return Container(
    child: Text('${note.name}', style: caption(color: Colors.white)),
    margin: const EdgeInsets.only(right: 5.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
        color: note.fromHex()),
    padding: EdgeInsets.all(7.0),
  );
}

/// Given a slider, applies the black slider theme.
Widget blackSliderTheme(Slider slider) {
  return SliderTheme(
    data: SliderThemeData(
      activeTrackColor: Colors.black87,
      inactiveTrackColor: Colors.black12,
      trackHeight: 1.0,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
      thumbColor: Colors.black87,
      overlayColor: Colors.grey.withAlpha(32),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
      tickMarkShape: RoundSliderTickMarkShape(),
      activeTickMarkColor: Colors.black,
      inactiveTickMarkColor: Colors.black,
    ),
    child: slider,
  );
}
