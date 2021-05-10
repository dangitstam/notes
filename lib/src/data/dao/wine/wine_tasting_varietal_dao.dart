import 'package:flutter/material.dart';
import 'package:notes/src/data/constants.dart';
import 'package:notes/src/data/model/wine/varietal.dart';
import 'package:notes/src/data/model/wine/wine_tasting_note.dart';
import 'package:sqflite/sqflite.dart';

class WineTastingVarietalDao {
  @required
  Future<Database> database;

  WineTastingVarietalDao({this.database});

  Future<int> insert(Map<String, dynamic> newWineTastingVarietal) async {
    final db = await database;
    var res = await db.insert(WINE_TASTING_VARIETALS_TABLE_NAME, newWineTastingVarietal);
    return res;
  }

  /// Given a wine tasting, collect all varietals and their percentages and
  /// return them as a list of [Varietal].
  Future<List<Varietal>> getVarietalsForWine(int wineTastingId) async {
    final db = await database;
    var res = await db.rawQuery(
        // ignore: prefer_single_quotes
        """
        SELECT varietals.name,
               wine_tasting_varietals.percentage
          FROM wine_tasting_varietals
          JOIN varietals
            ON varietals.varietal_id == wine_tasting_varietals.varietal_id
        WHERE wine_tasting_varietals.wine_tasting_id == $wineTastingId
        """);
    var list = res.isNotEmpty
        ? res.map((c) {
            return Varietal.fromAppDatabase(c);
          }).toList()
        : <Varietal>[];
    return list;
  }
}
