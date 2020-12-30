import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/coffee_tasting_note.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:sqflite/sqflite.dart';

class CoffeeTastingNoteDao {
  Future<Database> database;

  CoffeeTastingNoteDao({this.database});

  Future<int> insert(Map<String, dynamic> newCoffeeTasting) async {
    final db = await database;
    var res = await db.insert('coffee_tasting_notes', newCoffeeTasting);
    return res;
  }

  Future<List<Note>> getCoffeeTastingNotes(CoffeeTasting coffeeTasting) async {
    final coffeeTastingId = coffeeTasting.coffeeTastingId;

    final db = await database;
    var res = await db.rawQuery(
        // ignore: prefer_single_quotes
        """
        WITH note_ids AS (
          SELECT note_id
          FROM coffee_tasting_notes
          WHERE coffee_tasting_id == $coffeeTastingId
        )
        SELECT name, color
        FROM notes
        WHERE note_id in note_ids
        """);
    var list = res.isNotEmpty
        ? res.map((c) {
            return Note.fromAppDatabase(c);
          }).toList()
        : <Note>[];
    return list;
  }

  Future<List<CoffeeTastingNote>> getAllCoffeeTastingNotes() async {
    final db = await database;
    var res = await db.query('coffee_tasting_notes');
    if (res.isEmpty) {
      return [];
    }

    var list = res.isNotEmpty
        ? res.map((c) {
            return CoffeeTastingNote.fromAppDatabase(c);
          }).toList()
        : <CoffeeTastingNote>[];
    return list;
  }
}
