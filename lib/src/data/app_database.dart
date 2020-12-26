import 'package:flutter/services.dart';
import 'package:notes/src/data/coffee_tasting.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
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
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'coffee_tasting_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        db.execute(
          // ignore: prefer_single_quotes
          """
          CREATE TABLE coffee_tastings(
            id INTEGER PRIMARY KEY,
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
            coffeeTastingBloc.inAddCoffeeTasting
                .add(CoffeeTasting.fromAppDatabase(coffee_tasting));
          });
        });
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<int> insert(Map<String, dynamic> newCoffeeTasting) async {
    final db = await database;
    var res = await db.insert('coffee_tastings', newCoffeeTasting);
    return res;
  }

  Future<List<CoffeeTasting>> getAllCoffeeTastings() async {
    final db = await database;
    var res = await db.query('coffee_tastings');
    var list = res.isNotEmpty
        ? res.map((c) {
            return CoffeeTasting.fromAppDatabase(c);
          }).toList()
        : <CoffeeTasting>[];
    return list;
  }
}
