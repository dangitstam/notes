import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/data/model/note.dart';

class EditableTextWithCaptionWidget extends StatelessWidget {
  final String label;
  final String hint;
  final Function onChanged;

  EditableTextWithCaptionWidget({this.label, this.hint, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hintColor = Theme.of(context).hintColor;
    final hintStyle = Theme.of(context).textTheme.bodyText2.copyWith(color: hintColor);
    return TextField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label.toUpperCase(),
            labelStyle: Theme.of(context).textTheme.overline),
        style: hintStyle,
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
        style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
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
