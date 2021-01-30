import 'package:flutter/material.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:sqflite/sqflite.dart';

class NoteDao {
  @required
  Future<Database> database;

  NoteDao({this.database});

  Future<int> insert(Map<String, dynamic> newNote) async {
    final db = await database;
    var res = await db.insert('notes', newNote);
    return res;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var res = await db.query('notes');
    var list = res.isNotEmpty
        ? res.map((c) {
            return Note.fromAppDatabase(c);
          }).toList()
        : <Note>[];
    return list;
  }
}
