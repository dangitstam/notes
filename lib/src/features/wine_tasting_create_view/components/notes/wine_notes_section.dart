import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

import '../section_title.dart';
import 'interactive_tasting_note.dart';
import 'new_category_dialog.dart';

class WineNotesScreen extends StatefulWidget {
  @override
  _WineNotesScreenState createState() => _WineNotesScreenState();
}

class _WineNotesScreenState extends State<WineNotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'Edit Notes',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.xmark,
            color: Theme.of(context).colorScheme.onSurface,
            size: 32,
          ),
        ),
      ),
      body: NotesSection(),
    );
  }
}

class NotesSection extends StatefulWidget {
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  @override
  Widget build(BuildContext context) {
    var wineTastingState = context.watch<WineTastingCreateBloc>().state.tasting;
    var selectedTastingNotes = wineTastingState.notes;

    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Column(
        children: [
          SectionTitle(sectionNumber: 2, title: 'Notes'),
          SizedBox(height: 15),
          Center(
            child: Text(
              'Select all that apply.',
              style: Theme.of(context).textTheme.caption,
            ),
          ),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            direction: Axis.horizontal,
            spacing: 5,
            children: selectedTastingNotes.map((e) => RemoveTastingNote(e)).toList(),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder(
                stream: BlocProvider.of<WineTastingCreateBloc>(context).notesCategorized,
                builder: (context, AsyncSnapshot<Map<NoteCategory, List<Note>>> snapshot) {
                  var notesCategorized = snapshot.data;
                  if (notesCategorized != null) {
                    return Column(
                      // Listify the entries and make a map of the result to get
                      // an integer position index for each entry.
                      children: notesCategorized.entries.toList().asMap().entries.map((entry) {
                        final index = entry.key;

                        // ignore: omit_local_variable_types
                        MapEntry<NoteCategory, List<Note>> notesCategorizedEntry = entry.value;
                        final category = notesCategorizedEntry.key;
                        final notes = notesCategorizedEntry.value;

                        // List of mixed widget types is possible, but breaks when attempting to
                        // add a new widget type to a list of a single type constructed with a comprehension.
                        // Use loops as a workaround.
                        // ignore: omit_local_variable_types
                        List<Widget> children = [];
                        for (var note in notes) {
                          children.add(AddTastingNote(note));
                        }
                        children.add(
                          CreateTastingNote(category),
                        );
                        return Column(
                          children: [
                            Theme(
                              // Remove borders drawn by the expansion tile.
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: index == 0,
                                title: Text(
                                  category.name.toUpperCase(),
                                  style: Theme.of(context).textTheme.overline,
                                ),
                                children: [
                                  Wrap(
                                    spacing: 5,
                                    alignment: WrapAlignment.center,
                                    children: children,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 17),
          TextButton(
            style: Theme.of(context).outlinedButtonTheme.style,
            child: Text('+ Add Note Category'.toUpperCase()),
            onPressed: () {
              // BLoC is out of scope for the modal since it exists outside of the widget tree.
              final onSubmitted = (value) {
                context.read<WineTastingCreateBloc>().add(
                      CreateWineTastingNoteCategoryEvent(
                        noteCategory: NoteCategory(name: value),
                      ),
                    );
                Navigator.pop(context);
              };
              showDialog(
                context: context,
                builder: (context) {
                  return NewCategoryDialog(
                    onSubmitted: onSubmitted,
                  );
                },
              );
            },
          ),
          const SizedBox(height: 34),
        ],
      ),
    );
  }
}
