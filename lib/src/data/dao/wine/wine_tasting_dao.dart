import 'package:flutter/material.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:sqflite/sqflite.dart';

class WineTastingDao {
  @required
  Future<Database> database;

  WineTastingDao({this.database});

  Future<int> insert(Map<String, dynamic> newWineTasting) async {
    final db = await database;
    var res = await db.insert('wine_tastings', newWineTasting);
    return res;
  }

  Future<List<WineTasting>> getAllWineTastings() async {
    final db = await database;
    var res = await db.query('wine_tastings');
    var list = res.isNotEmpty
        ? res.map((c) {
            return WineTasting.fromAppDatabase(c);
          }).toList()
        : <WineTasting>[];
    return list;
  }
}
