import 'dart:async';

import 'package:notes/src/data/app_database.dart';

import 'dao/wine/wine_tasting_dao.dart';
import 'dao/wine/wine_tasting_note_dao.dart';
import 'model/wine/wine_tasting.dart';

class WineTastingRepository {
  final WineTastingDao _wineTastingDao = WineTastingDao(database: AppDatabase.db.database);

  final WineTastingNoteDao _wineTastingNotesDao = WineTastingNoteDao(database: AppDatabase.db.database);

  Future<int> insert(WineTasting wineTasting) {
    return _wineTastingDao.insert(wineTasting.toMap());
  }

  Future<List<WineTasting>> getWineTastings() async {
    // Retrieve all the wine tastings from the database.
    var wineTastings = await _wineTastingDao.getAllWineTastings();

    // Collect tasting notes for each wine tasting.
    for (var i = 0; i < wineTastings.length; i++) {
      final notes = await _wineTastingNotesDao.getWineTastingNotes(wineTastings[i].wineTastingId);
      wineTastings[i] = wineTastings[i].copyWith(notes: notes);
    }

    return wineTastings;
  }
}