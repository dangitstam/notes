import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';

import '../section_title.dart';
import 'interactive_tasting_note.dart';
import 'new_category_dialog.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
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
        actions: [
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: TextButton(
          //     style: Theme.of(context).outlinedButtonTheme.style,
          //     child: Text('Next'.toUpperCase()),
          //     onPressed: () {
          //       Navigator.pushNamed(context, '/characteristics');
          //     },
          //   ),
          // )
        ],
      ),
      body: NotesSection(),
    );
  }
}

class NotesSection extends StatefulWidget {
  @override
  _NotesSectionState createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> with AutomaticKeepAliveClientMixin<NotesSection> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    var coffeeTastingState = context.watch<CoffeeTastingCreateBloc>().state.tasting;
    var selectedTastingNotes = coffeeTastingState.notes;

    return ListView(
      padding: EdgeInsets.all(10.0),
      children: [
        SectionTitle(sectionNumber: 2, title: 'Notes'),
        SizedBox(height: 15),
        Center(
          child: Text(
            'Select all that apply',
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
        StreamBuilder(
          stream: BlocProvider.of<CoffeeTastingCreateBloc>(context).notesCategorized,
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
        SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // BLoC is out of scope for the modal since it exists outside of the widget tree.
            final onSubmitted = (value) {
              context.read<CoffeeTastingCreateBloc>().add(
                    CreateCoffeeTastingNoteCategoryEvent(
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
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Icon(CupertinoIcons.add),
              SizedBox(width: 20),
              Text('New Note Category'.toUpperCase(), style: Theme.of(context).textTheme.overline),
            ],
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
