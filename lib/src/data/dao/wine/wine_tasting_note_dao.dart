import 'package:flutter/material.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/wine/wine_tasting_note.dart';
import 'package:sqflite/sqflite.dart';

class WineTastingNoteDao {
  @required
  Future<Database> database;

  WineTastingNoteDao({this.database});

  Future<int> insert(Map<String, dynamic> newWineTastingNote) async {
    final db = await database;
    var res = await db.insert('wine_tasting_notes', newWineTastingNote);
    return res;
  }

  Future<List<Note>> getWineTastingNotes(int wineTastingId) async {
    final db = await database;
    var res = await db.rawQuery(
        // ignore: prefer_single_quotes
        """
        WITH note_ids AS (
          SELECT note_id
          FROM wine_tasting_notes
          WHERE wine_tasting_id == $wineTastingId
        )
        SELECT note_id, name, color
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

  Future<List<WineTastingNote>> getAllWineTastingNotes() async {
    final db = await database;
    var res = await db.query('wine_tasting_notes');
    if (res.isEmpty) {
      return [];
    }

    var list = res.isNotEmpty
        ? res.map((c) {
            return WineTastingNote.fromAppDatabase(c);
          }).toList()
        : <WineTastingNote>[];
    return list;
  }
}
