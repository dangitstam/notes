import 'package:flutter/services.dart';
import 'package:notes/src/data/coffee_tasting.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CoffeeTastingDao {
  Future<Database> database;

  CoffeeTastingDao({this.database});

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
