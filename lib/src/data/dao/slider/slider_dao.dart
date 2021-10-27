import 'package:flutter/material.dart';
import 'package:notes/src/data/model/slider/slider.dart';
import 'package:sqflite/sqflite.dart';

class SliderDao {
  @required
  Future<Database> database;

  SliderDao({this.database});

  Future<int> insert(Map<String, dynamic> newSlider) async {
    final db = await database;
    var res = await db.insert('sliders', newSlider);
    return res;
  }

  Future<List<CustomSlider>> getAllSliders() async {
    final db = await database;
    var res = await db.query('sliders');
    var list = res.isNotEmpty
        ? res.map((s) {
            return CustomSlider.fromAppDatabase(s);
          }).toList()
        : <CustomSlider>[];
    return list;
  }
}
