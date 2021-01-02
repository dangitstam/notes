import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/note.dart';

import 'dart:async';
import 'package:notes/src/data/dao/note_dao.dart';

class NoteBloc {
  final NoteDao _noteDao = NoteDao(database: AppDatabase.db.database);

  NoteBloc() {
    getNotes(); // Retrieve all tastings on init.
  }

  // Controller: Page <- App Database.
  final _getNotesController = StreamController<List<Note>>.broadcast();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<Note>> get _inNotes => _getNotesController.sink;

  void dispose() {
    _getNotesController.close();
  }

  void getNotes() async {
    // Retrieve all the notes from the database.
    var notes = await _noteDao.getAllNotes();

    // Update the notes output stream so subscribing pages can update.
    _inNotes.add(notes);
  }

  /// Repository API

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for notes.
  Stream<List<Note>> get notes => _getNotesController.stream.asBroadcastStream();

  Future<int> insert(Note note) async {
    final noteId = await _noteDao.insert(note.toMap());

    // Update output stream on every insertion.
    getNotes();

    return noteId;
  }
}
