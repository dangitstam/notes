import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

import 'dart:async';

import 'package:notes/src/data/dao/coffee_tasting_dao.dart';

import 'dao/coffee_tasting_note_dao.dart';

class CoffeeTastingRepository {
  final CoffeeTastingDao _coffeeTastingDao = CoffeeTastingDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNotesDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

  Future<int> insert(CoffeeTasting coffeeTasting) {
    return _coffeeTastingDao.insert(coffeeTasting.toMap());
  }
}
