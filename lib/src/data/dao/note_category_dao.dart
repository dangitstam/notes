import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
import 'package:sqflite/sqflite.dart';

class NoteCategoryDao {
  Future<Database> database;

  NoteCategoryDao({this.database});

  Future<int> insert(Map<String, dynamic> noteCategory) async {
    final db = await database;
    var res = await db.insert('note_categories', noteCategory);
    return res;
  }

  Future<List<NoteCategory>> getAllNoteCategories() async {
    final db = await database;
    var res = await db.query('note_categories');
    if (res.isEmpty) {
      return [];
    }

    var list = res.isNotEmpty
        ? res.map((c) {
            return NoteCategory.fromAppDatabase(c);
          }).toList()
        : <NoteCategory>[];
    return list;
  }
}
