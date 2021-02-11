import 'package:sqflite/sqflite.dart';

Future<void> createWineTastingsTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE wine_tastings(
      wine_tasting_id INTEGER PRIMARY KEY,
      name TEXT,
      description TEXT,
      origin TEXT,
      process TEXT,
      roaster TEXT,
      varietals TEXT,
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
  );
}

Future<void> createWineTastingNotesTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE wine_tasting_notes(
      wine_tasting_id INTEGER,
      note_id INTEGER)
    """,
  );
}
