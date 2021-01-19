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
      listener: (BuildContext context, CoffeeTastingCreateState state) {
        if (!state.tasting.notes.contains(widget.note)) {
          _enabled = true;
        }
      },
      child: ActionChip(
        onPressed: _enabled
            ? () {
                context.read<CoffeeTastingCreateBloc>().add(AddCoffeeTastingNoteEvent(note: widget.note));
                _enabled = false;
              }
            : () {},
        label: Text(
          '${widget.note.name}',
          style: caption(color: Colors.white),
        ),
        backgroundColor: _enabled ? widget.note.getColor() : widget.note.getColor().withOpacity(0.6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
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
        // For Flutter's standard chip, the onDeleted target is only the delete icon.
        // Uses ActionChip instead to allow tapping anywhere on the chip for deletion.
        return ActionChip(
          onPressed: () {
            context.read<CoffeeTastingCreateBloc>().add(RemoveCoffeeTastingNoteEvent(note: note));
          },
          avatar: Icon(
            CupertinoIcons.xmark,
            color: Colors.white,
            size: 10,
          ),
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
      },
    );
  }
}
