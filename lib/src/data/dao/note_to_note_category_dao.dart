import 'package:notes/src/data/model/note_to_note_category.dart';
import 'package:sqflite/sqflite.dart';

class NoteToNoteCategoryDao {
  Future<Database> database;

  NoteToNoteCategoryDao({this.database});

  Future<int> insert(Map<String, dynamic> noteToNoteCategory) async {
    final db = await database;
    var res = await db.insert('note_to_note_categories', noteToNoteCategory);
    return res;
  }

  Future<List<NoteToNoteCategory>> getNoteToNoteRelations() async {
    final db = await database;

    var rawNotesToNoteCategories = await db.query('note_to_note_categories');
    var noteToNoteCategories = rawNotesToNoteCategories.isNotEmpty
        ? rawNotesToNoteCategories.map((c) {
            return NoteToNoteCategory.fromAppDatabase(c);
          }).toList()
        : <NoteToNoteCategory>[];

    return noteToNoteCategories;
  }
}
