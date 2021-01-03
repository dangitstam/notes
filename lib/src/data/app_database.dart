import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/note_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/coffee_tasting_note_dao.dart';

class AppDatabase {
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  static Database _database;

  Future<Database> get database async {
    // Lazy instantiation of the app database.
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'coffee_tasting_database.db'),
      onCreate: (db, version) {
        _createCoffeeTastingsTable(db);
        _createNotesTable(db);
        _createCoffeeTastingNotesTable(db);
      },
      version: 1,
    );
  }
}

Future<void> _createCoffeeTastingsTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
          CREATE TABLE coffee_tastings(
            coffee_tasting_id INTEGER PRIMARY KEY,
            coffee_name TEXT,
            description TEXT,
            origin TEXT,
            process TEXT,
            roaster TEXT,
            notes TEXT,
            roast_level REAL,
            acidity REAL,
            aftertaste REAL,
            body REAL,
            flavor REAL,
            fragrance REAL)
          """,
  ).then((_) async {
    // For development purposes, populate the database from the
    // coffee_tastings.json asset.
    var coffeeTastingsString = await rootBundle.loadString('assets/coffee_tastings.json');
    List<dynamic> coffeeTastings = json.decode(coffeeTastingsString);

    var coffeeTastingRepository = CoffeeTastingRepository();
    for (var coffeeTasting in coffeeTastings) {
      await coffeeTastingRepository.insert(CoffeeTasting.fromAppDatabase(coffeeTasting));
    }
  });
}

Future<void> _createNotesTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE notes(
      note_id INTEGER PRIMARY KEY,
      name TEXT,
      color TEXT)
    """,
  ).then((_) async {
    // For development purposes, populate the database from the notes.json asset.
    var note_string = await rootBundle.loadString('assets/notes.json');
    List<dynamic> notes = json.decode(note_string);
    var noteRepository = NoteRepository();
    notes.forEach((note) {
      noteRepository.insert(Note.fromAppDatabase(note));
    });
  });
}

Future<void> _createCoffeeTastingNotesTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE coffee_tasting_notes(
      coffee_tasting_id INTEGER,
      note_id INTEGER)
    """,
  ).then((_) async {
    // For development purposes, populate the database from the notes.json asset.
    var coffeeTastingNotesString = await rootBundle.loadString('assets/coffee_tastings_notes.json');

    // Update stream so that the downstream list view is updated.
    var coffeeTastingDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

    List<dynamic> coffeeTastingNotes = json.decode(coffeeTastingNotesString);
    coffeeTastingNotes.forEach((coffeeTastingNote) {
      coffeeTastingDao.insert(coffeeTastingNote);
    });
  });
}
