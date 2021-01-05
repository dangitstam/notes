import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/styles/typography.dart';

class AddTastingNote extends StatefulWidget {
  final Note note;

  AddTastingNote(this.note);

  @override
  _AddTastingNoteState createState() => _AddTastingNoteState();
}

class _AddTastingNoteState extends State<AddTastingNote> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      listener: (context, state) {
        if (!state.notes.contains(widget.note)) {
          _enabled = true;
        }
      },
      child: GestureDetector(
        onTap: _enabled
            ? () {
                context.read<CoffeeTastingCreateBloc>().add(AddCoffeeTastingNoteEvent(note: widget.note));
                _enabled = false;
              }
            : null,
        child: Container(
          child: Text('${widget.note.name}', style: caption(color: Colors.white)),
          margin: const EdgeInsets.only(right: 5.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
              color: _enabled ? widget.note.fromHex() : widget.note.fromHex().withOpacity(0.7)),
          padding: EdgeInsets.all(7.0),
        ),
      ),
    );
  }
}

class RemoveTastingNote extends StatelessWidget {
  final Note note;
  RemoveTastingNote(this.note);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            context.read<CoffeeTastingCreateBloc>().add(
                  RemoveCoffeeTastingNoteEvent(note: note),
                );
          },
          child: Container(
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.xmark,
                  color: Colors.white,
                  size: 10,
                ),
                SizedBox(width: 5),
                Text('${note.name}', style: caption(color: Colors.white)),
              ],
            ),
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(6.0)), color: note.fromHex()),
            padding: EdgeInsets.all(7.0),
          ),
        );
      },
    );
  }
}
