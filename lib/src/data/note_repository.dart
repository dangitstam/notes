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
    List<Note> notes = await _noteDao.getAllNotes();
    List<NoteCategory> noteCategories = await _noteCategoryDao.getAllNoteCategories();
    List<NoteToNoteCategory> noteToNoteCategories = await _noteToNoteCategoryDao.getNoteToNoteRelations();

    // Without a type annotation for `res`, this method will hang when awaited.
    Map<NoteCategory, List<Note>> res = {};

    Map<int, Note> notesMapped = {for (Note element in notes) element.id: element};
    Map<int, NoteCategory> noteCategoriesMapped = {for (NoteCategory element in noteCategories) element.id: element};

    for (NoteToNoteCategory noteToNoteCategory in noteToNoteCategories) {
      // Without .toList(), the resulting iterable will case this method to hang.
      var note = notesMapped[noteToNoteCategory.note_id];
      var noteCategory = noteCategoriesMapped[noteToNoteCategory.note_category_id];

      if (note != null && noteCategory != null) {
        if (res[noteCategory] != null) {
          res[noteCategory].add(note);
        } else {
          res[noteCategory] = [note];
        }
      }
    }

    return res;
  }
}
