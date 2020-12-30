import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/note.dart';

import 'dart:async';
import 'package:notes/src/data/dao/note_dao.dart';

class NoteBloc {
  // Singleton instantiation.
  static final NoteBloc _instance = NoteBloc._internal();
  static NoteBloc get instance => _instance;

  final NoteDao _noteDao = NoteDao(database: AppDatabase.db.database);

  NoteBloc._internal() {
    getNotes(); // Retrieve all tastings on init.

    // Process insertion requests as an input stream, inserting
    // notes one at a time into the app database.
    // `coffeeTastings` is updated on each insertion.
    _addNoteController.stream.listen(_handleAddNote);
  }

  // Controller: Page <- App Database.
  final _getNotesController = StreamController<List<Note>>.broadcast();

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for notes.
  Stream<List<Note>> get coffeeTastings => _getNotesController.stream;

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<Note>> get _inNotes => _getNotesController.sink;

  // Controller: Page -> App Database.
  final _addNoteController = StreamController<Note>.broadcast();

  // Stream: In
  // Purpose: Insertion into app database.
  StreamSink<Note> get inAddCoffeeTasting => _addNoteController.sink;

  void dispose() {
    _getNotesController.close();
    _addNoteController.close();
  }

  void getNotes() async {
    // Retrieve all the notes from the database.
    var coffeeTastings = await _noteDao.getAllNotes();

    // Update the notes output stream so subscribing pages can update.
    _inNotes.add(coffeeTastings);
  }

  void _handleAddNote(Note note) async {
    // Update output stream on every insertion.
    await _noteDao.insert(note.toMap());
    getNotes();
  }
}
