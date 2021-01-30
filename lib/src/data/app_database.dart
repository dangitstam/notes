import 'dart:convert' show json;

import 'package:flutter/services.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/dao/note_category_dao.dart';
import 'package:notes/src/data/dao/note_to_note_category_dao.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dao/coffee_tasting_note_dao.dart';
import 'dao/note_dao.dart';

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
        _createNoteCategoriesTable(db);
        _createNoteToNoteCategoriesTable(db);
      },
      onUpgrade: (db, v1, v2) {
        _createCoffeeTastingsTable(db);
        _createNotesTable(db);
        _createCoffeeTastingNotesTable(db);
        _createNoteCategoriesTable(db);
        _createNoteToNoteCategoriesTable(db);
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
            aroma_score REAL,
            aroma_intensity REAL,
            acidity_score REAL,
            acidity_intensity REAL,
            body_score REAL,
            body_level REAL,
            sweetness_score REAL,
            sweetness_intensity REAL,
            finish_score REAL,
            finish_duration REAL,
            flavor_score REAL,
            image_path TEXT)
          """,
  ).then((_) async {
    // For development purposes, populate example tastings from the coffee_tastings.json asset.
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
    // Populate stock notes from the notes.json asset.
    var note_string = await rootBundle.loadString('assets/notes.json');
    List<dynamic> notes = json.decode(note_string);
    var noteDao = NoteDao(database: AppDatabase.db.database);
    notes.forEach((note) {
      noteDao.insert(note);
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
    // For development purposes, populate notes for example tastings from the coffee_tastings_notes.json asset.
    var coffeeTastingNotesString = await rootBundle.loadString('assets/coffee_tastings_notes.json');

    var coffeeTastingDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);
    List<dynamic> coffeeTastingNotes = json.decode(coffeeTastingNotesString);
    coffeeTastingNotes.forEach((coffeeTastingNote) {
      coffeeTastingDao.insert(coffeeTastingNote);
    });
  });
}

Future<void> _createNoteCategoriesTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE note_categories(
      note_category_id INTEGER PRIMARY KEY,
      name TEXT,
      color TEXT)
    """,
  ).then((_) async {
    // Populate stock note categories from the note_categories.json asset.
    var noteCategoriesString = await rootBundle.loadString('assets/note_categories.json');
    List<dynamic> noteCategories = json.decode(noteCategoriesString);

    var noteCategoryDao = NoteCategoryDao(database: AppDatabase.db.database);
    noteCategories.forEach((noteCategory) {
      noteCategoryDao.insert(noteCategory);
    });
  });
}

Future<void> _createNoteToNoteCategoriesTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE note_to_note_categories(
      note_id INTEGER,
      note_category_id INTEGER)
    """,
  ).then((_) async {
    // Populate stock note to note category relations from the note_to_note_categories.json asset.
    var noteToNoteCategoryString = await rootBundle.loadString('assets/note_to_note_categories.json');

    var noteToNoteCategoryDao = NoteToNoteCategoryDao(database: AppDatabase.db.database);
    List<dynamic> noteToNoteCategoryEntries = json.decode(noteToNoteCategoryString);
    noteToNoteCategoryEntries.forEach((noteToNoteCategory) {
      noteToNoteCategoryDao.insert(noteToNoteCategory);
    });
  });
}
