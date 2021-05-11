import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/wine/varietal.dart';

import 'dao/varietal_dao.dart';
import 'dao/wine/wine_tasting_varietal_dao.dart';

class VarietalRepository {
  final VarietalDao _varietalDao = VarietalDao(database: AppDatabase.db.database);
  final WineTastingVarietalDao _wineTastingVarietalDao = WineTastingVarietalDao(database: AppDatabase.db.database);

  /// Inserts a new varietal and returns its id. Returns null if unsuccessful.
  Future<int> insert(Varietal varietal) async {
    // Percentage used only when associating varietals with a wine.
    var varietal_id = await _varietalDao.insert(
      {
        'name': varietal.name,
      },
    );

    // Case in which the varietal already existed, look up and return the id.
    if (varietal_id == null) {
      return _varietalDao.getIdByName(varietal.name);
    }

    return varietal_id;
  }

  /// Relate a varietal to a wine.
  Future<int> insertWineTastingVarietal({
    @required int varietalId,
    @required int wineTastingId,
    @required int percentage,
  }) {
    return _wineTastingVarietalDao.insert(
      {'varietal_id': varietalId, 'wine_tasting_id': wineTastingId, 'percentage': percentage},
    );
  }

  /// Insert a new varietal for a wine.
  /// If the varietal itself has not been seen before, the varietal will also be inserted.
  Future<int> insertVarietalForWine(int wineTastingId, Varietal varietal) async {
    int varietalId = await insert(varietal);
    return insertWineTastingVarietal(
      varietalId: varietalId,
      wineTastingId: wineTastingId,
      percentage: varietal.percentage,
    );
  }

  /// Collect all varietals for a given wine and return as a list of [Varietal].
  Future<List<Varietal>> getVarietalsForWine(int wineTastingId) {
    return _wineTastingVarietalDao.getVarietalsForWine(wineTastingId);
  }
}
