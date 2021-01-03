import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/dao/coffee_tasting_dao.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

import 'dao/coffee_tasting_note_dao.dart';

class CoffeeTastingRepository {
  final CoffeeTastingDao _coffeeTastingDao = CoffeeTastingDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNotesDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

  Future<int> insert(CoffeeTasting coffeeTasting) {
    return _coffeeTastingDao.insert(coffeeTasting.toMap());
  }

  Future<List<CoffeeTasting>> getCoffeeTastings() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await _coffeeTastingDao.getAllCoffeeTastings();

    // Collect tasting notes for each coffee tasting.
    for (var coffeeTasting in coffeeTastings) {
      final notes = await _coffeeTastingNotesDao.getCoffeeTastingNotes(coffeeTasting.coffeeTastingId);
      coffeeTasting.notes = notes;
    }

    return coffeeTastings;
  }
}
