import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/styles/typography.dart';

class EditableTextWithCaptionWidget extends StatelessWidget {
  final String label;
  final String hint;
  final Function onChanged;

  EditableTextWithCaptionWidget({this.label, this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            labelStyle: subtitle_1()),
        style: body_1(),
        onChanged: (value) => onChanged(value));
  }
}

/// Given a tasting note, creates a widget containing the note name
/// filled with the note's color.
class TastingNote extends StatelessWidget {
  final Note note;

  TastingNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        '${note.name}',
        style: caption(color: Colors.white),
      ),
      backgroundColor: note.getColor(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    );
  }
}

/// Given a slider, applies the black slider theme.
class BlackSliderTheme extends StatelessWidget {
  final Slider slider;

  BlackSliderTheme(this.slider);

  @override
  Widget build(BuildContext context) {
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
}

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
