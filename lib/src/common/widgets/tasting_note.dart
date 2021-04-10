import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/data/model/note.dart';

/// Given a tasting note, creates a widget containing the note name
/// filled with the note's color.
class TastingNote extends StatelessWidget {
  final Note note;

  TastingNote(this.note);

  @override
  Widget build(BuildContext context) {
    return Chip(
      // This chip is not meant to be tapped, but `shrinkWrap`
      // will tighten the chip's surrounding padding.
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
