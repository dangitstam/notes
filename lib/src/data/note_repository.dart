import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/dao/note_dao.dart';
import 'package:notes/src/data/model/note.dart';

class NoteRepository {
  final NoteDao _noteDao = NoteDao(database: AppDatabase.db.database);

  Future<int> insert(Note note) => _noteDao.insert(note.toMap());

  Future<List<Note>> getAllNotes() => _noteDao.getAllNotes();
}
