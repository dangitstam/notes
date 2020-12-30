import 'package:flutter/services.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/notes_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:convert' show json;

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
    var coffee_tastings_string =
        await rootBundle.loadString('assets/coffee_tastings.json');

    // Update stream so that the downstream list view is updated.
    List<dynamic> coffee_tastings = json.decode(coffee_tastings_string);
    var coffeeTastingBloc = CoffeeTastingBloc.instance;
    coffee_tastings.forEach((coffee_tasting) {
      coffeeTastingBloc.insert(CoffeeTasting.fromAppDatabase(coffee_tasting));
    });
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

    // Update stream so that the downstream list view is updated.
    List<dynamic> notes = json.decode(note_string);
    var notesBloc = NoteBloc.instance;
    notes.forEach((note) {
      notesBloc.inAddNote.add(Note.fromAppDatabase(note));
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
    var note_string = await rootBundle.loadString('assets/notes.json');

    // Update stream so that the downstream list view is updated.
    List<dynamic> notes = json.decode(note_string);
    var notesBloc = NoteBloc.instance;
    notes.forEach((note) {
      notesBloc.inAddNote.add(Note.fromAppDatabase(note));
    });
  });
}
