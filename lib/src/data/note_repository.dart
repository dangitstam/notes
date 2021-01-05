import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/dao/coffee_tasting_note_dao.dart';
import 'package:notes/src/data/dao/note_dao.dart';
import 'package:notes/src/data/model/note.dart';

class NoteRepository {
  final NoteDao _noteDao = NoteDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNoteDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

  Future<int> insert(Note note) => _noteDao.insert(note.toMap());

  Future<int> insertNoteForCoffeeTasting(int noteId, int coffeeTastingId) {
    return _coffeeTastingNoteDao.insert(
      {'coffee_tasting_id': coffeeTastingId, 'note_id': noteId},
    );
  }

  Future<List<Note>> getAllNotes() => _noteDao.getAllNotes();
}
