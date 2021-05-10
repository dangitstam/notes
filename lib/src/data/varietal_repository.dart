import 'dart:async';

import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/wine/varietal.dart';

import 'dao/varietal_dao.dart';
import 'dao/wine/wine_tasting_varietal_dao.dart';

class VarietalRepository {
  final VarietalDao _varietalDao = VarietalDao(database: AppDatabase.db.database);
  final WineTastingVarietalDao _wineTastingVarietalDao = WineTastingVarietalDao(database: AppDatabase.db.database);

  /// Insert a new varietal.
  Future<int> insert(Varietal varietal) {
    // Percentage used only when associating varietals with a wine.
    return _varietalDao.insert(
      {
        'name': varietal.name,
      },
    );
  }

  /// Relate a varietal to a wine.
  Future<int> insertWineTastingVarietal(int varietalId, int wineTastingId, int percentage) {
    print('entered VarietalRepository.insertVarietalForWine');

    return _wineTastingVarietalDao.insert(
      {'varietal_id': varietalId, 'wine_tasting_id': wineTastingId, 'percentage': percentage},
    );
  }

  /// Insert a new varietal for a wine.
  /// If the varietal itself has not ben seen before, the varietal will also be inserted.
  Future<int> insertVarietalForWine(int wineTastingId, Varietal varietal) async {
    print('entered VarietalRepository.insertVarietalForWine');
    int varietalId = await insert(varietal);
    return insertWineTastingVarietal(varietalId, wineTastingId, varietal.percentage);
  }

  /// Collect all varietals for a given wine and return as a list of [Varietal].
  Future<List<Varietal>> getVarietalsForWine(int wineTastingId) {
    return _wineTastingVarietalDao.getVarietalsForWine(wineTastingId);
  }
}
