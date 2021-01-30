import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/dao/coffee_tasting_note_dao.dart';
import 'package:notes/src/data/dao/note_category_dao.dart';
import 'package:notes/src/data/dao/note_dao.dart';
import 'package:notes/src/data/dao/note_to_note_category_dao.dart';
import 'package:notes/src/data/model/note.dart';

import 'model/note_category.dart';
import 'model/note_to_note_category.dart';

class NoteRepository {
  final NoteDao _noteDao = NoteDao(database: AppDatabase.db.database);
  final NoteCategoryDao _noteCategoryDao = NoteCategoryDao(database: AppDatabase.db.database);
  final NoteToNoteCategoryDao _noteToNoteCategoryDao = NoteToNoteCategoryDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNoteDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

  Future<int> insert(Note note) => _noteDao.insert(note.toMap());

  Future<int> insertNoteCategory(NoteCategory noteCategory) => _noteCategoryDao.insert(noteCategory.toMap());

  /// Relate a note to a note category.
  Future<int> insertNoteToNoteCategory(int noteId, int noteCategoryId) => _noteToNoteCategoryDao.insert(
        {'note_id': noteId, 'note_category_id': noteCategoryId},
      );

  Future<int> insertNoteForCoffeeTasting(int noteId, int coffeeTastingId) {
    return _coffeeTastingNoteDao.insert(
      {'coffee_tasting_id': coffeeTastingId, 'note_id': noteId},
    );
  }

  Future<List<Note>> getAllNotes() => _noteDao.getAllNotes();

  Future<Map<NoteCategory, List<Note>>> getNotesCategorized() async {
    var notes = await _noteDao.getAllNotes();
    var noteCategories = await _noteCategoryDao.getAllNoteCategories();
    var noteToNoteCategories = await _noteToNoteCategoryDao.getNoteToNoteRelations();

    // Ignore the type annotation linting error because without an annotation,
    // this method will hang when awaited.
    // ignore: omit_local_variable_types
    Map<NoteCategory, List<Note>> res = {};
    for (var noteCategory in noteCategories) {
      // Without .toList(), the resulting iterable will case this method to hang.
      var notesForCategory = notes.where((Note note) {
        return noteToNoteCategories.contains(
          NoteToNoteCategory(
            note_id: note.id,
            note_category_id: noteCategory.id,
          ),
        );
      }).toList();

      res[noteCategory] = notesForCategory;
    }

    return res;
  }
}
