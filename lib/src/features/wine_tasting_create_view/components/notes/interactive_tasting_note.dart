import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notes/src/common/widgets/editable_text_with_caption.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

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
    return BlocListener<WineTastingCreateBloc, WineTastingCreateState>(
      listener: (BuildContext context, WineTastingCreateState state) {
        // Defer triggering the change to the note widget's state until it is known
        // that the note has been added or removed.
        if (_enabled != !state.tasting.notes.contains(widget.note)) {
          setState(() {
            _enabled = !state.tasting.notes.contains(widget.note);
          });
        }
      },
      child: ActionChip(
        onPressed: _enabled
            ? () {
                context.read<WineTastingCreateBloc>().add(AddWineTastingNoteEvent(note: widget.note));
                setState(() {
                  _enabled = false;
                });
              }
            : () {},
        label: Text(
          '${widget.note.name}',
          style: Theme.of(context).textTheme.caption.copyWith(color: Colors.white),
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
    return BlocBuilder<WineTastingCreateBloc, WineTastingCreateState>(
      builder: (context, state) {
        // For Flutter's standard chip, the onDeleted target is only the delete icon.
        // Uses ActionChip instead to allow tapping anywhere on the chip for deletion.
        return ActionChip(
          onPressed: () {
            context.read<WineTastingCreateBloc>().add(RemoveWineTastingNoteEvent(note: note));
          },
          avatar: Icon(
            CupertinoIcons.xmark,
            color: Colors.white,
            size: 10,
          ),
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
      },
    );
  }
}

class CreateTastingNote extends StatefulWidget {
  final NoteCategory noteCategory;

  CreateTastingNote(this.noteCategory);

  @override
  _CreateTastingNoteState createState() => _CreateTastingNoteState();
}

class _CreateTastingNoteState extends State<CreateTastingNote> {
  Color _color = Color(0xff000000);
  String _name = 'New Note';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WineTastingCreateBloc, WineTastingCreateState>(
      builder: (context, state) {
        // Modal sheets exist outside of the widget tree, so they must be given
        // the bloc explicitly.
        final bloc = BlocProvider.of<WineTastingCreateBloc>(context);

        return Builder(
          builder: (BuildContext context) {
            return ActionChip(
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          runSpacing: 20,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                'New Note For ${widget.noteCategory.name}',
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            EditableTextWithCaptionWidget(
                              hint: 'Nectarine, Barnyard Funk, Sour Apple...',
                              label: 'Name',
                              onChanged: (name) {
                                setState(() {
                                  _name = name;
                                });
                              },
                            ),
                            Text(
                              'Color'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            ColorPicker(
                              pickerColor: _color,
                              enableAlpha: false,
                              onColorChanged: (color) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  _color = color;
                                });
                              },
                              showLabel: false,
                              pickerAreaHeightPercent: 0.8,
                            ),
                            Center(
                              child: TextButton(
                                child: Text('Create Note'.toUpperCase()),
                                style: Theme.of(context).textButtonTheme.style,
                                onPressed: () {
                                  bloc.add(
                                    CreateWineTastingNoteEvent(
                                      note: Note(
                                        color: '#${_color.value.toRadixString(16).substring(2)}',
                                        name: _name,
                                      ),
                                      noteCategory: widget.noteCategory,
                                    ),
                                  );
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              avatar: Icon(
                CupertinoIcons.add,
                color: Theme.of(context).colorScheme.onSurface,
                size: 14,
              ),
              label: Text(
                'Create new note',
                style: Theme.of(context).textTheme.caption,
              ),
              backgroundColor: Theme.of(context).backgroundColor,
            );
          },
        );
      },
    );
  }
}
