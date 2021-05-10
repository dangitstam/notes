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
      winemaker TEXT,
      alcohol_by_volume REAL,
      wine_type TEXT,
      bubbles TEXT,
      is_biodynamic INTEGER,
      is_organic_farming INTEGER,
      is_unfined_unfiltered INTEGER,
      is_no_added_sulfites INTEGER,
      is_wild_yeast INTEGER,
      is_ethically_made INTEGER,
      vintage INTEGER,
      acidity REAL,
      sweetness REAL,
      tannin REAL,
      body REAL,
      image_file_name TEXT,
      story TEXT)
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

Future<void> createVarietalsTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE varietals(
      varietal_id INTEGER PRIMARY KEY,
      name TEXT UNIQUE ON CONFLICT IGNORE)
    """,
  );
}

Future<void> createWineTastingVarietalsTable(Database db) {
  // Run the CREATE TABLE statement on the database.
  return db.execute(
    // ignore: prefer_single_quotes
    """
    CREATE TABLE wine_tasting_varietals(
      wine_tasting_id INTEGER,
      varietal_id INTEGER,
      percentage int)
    """,
  );
}
