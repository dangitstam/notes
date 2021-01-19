import 'dart:math';

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
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
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

Widget buildScaCriteriaCaption(String criteria) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0.0),
    child: Container(
      height: 40,
      child: Center(
        child: Text(
          '$criteria',
          textAlign: TextAlign.right,
          style: caption(),
        ),
      ),
    ),
  );
}

Widget buildScaCriteriaRatingLinearIndicator(double value) {
  var scaledValue = value / 10;
  var formattedValue = value == 10.0 ? 'Score: 10' : 'Score: $value';
  return Padding(
    padding: EdgeInsets.only(top: 2, bottom: 2),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.3),
          child: Container(
            height: 16,
            child: LinearProgressIndicator(
              backgroundColor: Color(0xffffffff),
              value: scaledValue,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1b1b1b)),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constrains) {
            // Subtracting a fixed amount ensures the value appears in the
            // colored part of the linear indicator and not outside of
            // the entire bar at any point.
            var leftPadding = max(constrains.maxWidth * scaledValue - 60, 0.0);
            return Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: Text('$formattedValue', style: caption(color: Colors.white, fontStyle: FontStyle.italic)),
            );
          },
        ),
      ],
    ),
  );
}

Widget buildScaCriteriaIntensityLinearIndicator(double value) {
  var scaledValue = value / 10;
  var formattedValue = value == 10.0 ? 'Intensity: 10' : 'Intensity: $value';
  return Padding(
    padding: EdgeInsets.only(top: 2, bottom: 7),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2.3),
          child: Container(
            height: 16,
            child: LinearProgressIndicator(
              backgroundColor: Color(0xffffffff),
              value: scaledValue,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff87bd91)),
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constrains) {
            // Subtracting a fixed amount ensures the value appears in the
            // colored part of the linear indicator and not outside of
            // the entire bar at any point.
            var leftPadding = max(constrains.maxWidth * scaledValue - 75, 0.0);
            return Padding(
              padding: EdgeInsets.only(left: leftPadding),
              child: Text('$formattedValue', style: caption(color: Colors.white, fontStyle: FontStyle.italic)),
            );
          },
        ),
      ],
    ),
  );
}
