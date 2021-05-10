import 'package:flutter/material.dart';
import 'package:notes/src/data/constants.dart';
import 'package:notes/src/data/model/wine/varietal.dart';
import 'package:sqflite/sqflite.dart';

class VarietalDao {
  @required
  Future<Database> database;

  VarietalDao({this.database});

  Future<int> insert(Map<String, dynamic> newVarietal) async {
    final db = await database;
    var res = await db.insert(VARIETALS_TABLE_NAME, newVarietal);
    return res;
  }

  Future<Varietal> get(int varietalId) async {
    final db = await database;

    var res = await db.rawQuery(
        // ignore: prefer_single_quotes
        """
        SELECT varietal_id, name
        FROM varietals
        WHERE varietal_id == $varietalId
        LIMIT 1
        """);

    if (res.isNotEmpty) {
      return Varietal.fromAppDatabase(res.first);
    }

    return null;
  }

  Future<List<Varietal>> getAllVarietals() async {
    final db = await database;
    var res = await db.query(VARIETALS_TABLE_NAME);
    var list = res.isNotEmpty
        ? res.map((c) {
            return Varietal.fromAppDatabase(c);
          }).toList()
        : <Varietal>[];
    return list;
  }
}
