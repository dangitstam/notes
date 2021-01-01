import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

import 'dart:async';

import 'package:notes/src/data/dao/coffee_tasting_dao.dart';

import 'dao/coffee_tasting_note_dao.dart';

class CoffeeTastingBloc {
  final CoffeeTastingDao _coffeeTastingDao =
      CoffeeTastingDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNotesDao =
      CoffeeTastingNoteDao(database: AppDatabase.db.database);

  CoffeeTastingBloc() {
    getCoffeeTastings(); // Retrieve all tastings on init.
  }

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController =
      StreamController<List<CoffeeTasting>>.broadcast();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings =>
      _getCoffeeTastingsController.sink;

  void dispose() {
    _getCoffeeTastingsController.close();
  }

  void getCoffeeTastings() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await _coffeeTastingDao.getAllCoffeeTastings();

    // Collect tasting notes for each coffee tasting.
    coffeeTastings.forEach((coffeeTasting) async {
      final notes = await _coffeeTastingNotesDao
          .getCoffeeTastingNotes(coffeeTasting.coffeeTastingId);
      coffeeTasting.notes = notes;
    });

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  /// Repository API

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings =>
      _getCoffeeTastingsController.stream;

  Future<int> insert(CoffeeTasting coffeeTasting) async {
    final coffeeTastingId =
        await _coffeeTastingDao.insert(coffeeTasting.toMap());

    // Update output stream on every insertion.
    getCoffeeTastings();

    return coffeeTastingId;
  }
}
