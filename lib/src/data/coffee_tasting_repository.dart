import 'package:notes/src/data/app_database.dart';
import 'package:notes/src/data/coffee_tasting.dart';

import 'dart:async';

import 'package:notes/src/data/dao/coffee_tasting_dao.dart';

class CoffeeTastingBloc {
  // Singleton instantiation.
  static final CoffeeTastingBloc _instance = CoffeeTastingBloc._internal();
  static CoffeeTastingBloc get instance => _instance;

  CoffeeTastingDao _coffeeTastingDao =
      CoffeeTastingDao(database: AppDatabase.db.database);

  CoffeeTastingBloc._internal() {
    getCoffeeTastings(); // Retrieve all tastings on init.

    // Process insertion requests as an input stream, inserting
    // coffee tastings one at a time into the app database.
    // `coffeeTastings` is updated on each insertion.
    _addCoffeeTastingsController.stream.listen(_handleAddCoffeeTasting);
  }

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController =
      StreamController<List<CoffeeTasting>>.broadcast();

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings =>
      _getCoffeeTastingsController.stream;

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings =>
      _getCoffeeTastingsController.sink;

  // Controller: Page -> App Database.
  final _addCoffeeTastingsController =
      StreamController<CoffeeTasting>.broadcast();

  // Stream: In
  // Purpose: Insertion into app database.
  StreamSink<CoffeeTasting> get inAddCoffeeTasting =>
      _addCoffeeTastingsController.sink;

  void dispose() {
    _getCoffeeTastingsController.close();
    _addCoffeeTastingsController.close();
  }

  void getCoffeeTastings() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await _coffeeTastingDao.getAllCoffeeTastings();

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  void _handleAddCoffeeTasting(CoffeeTasting note) async {
    // Update output stream on every insertion.
    await _coffeeTastingDao.insert(note.toMap());
    getCoffeeTastings();
  }
}
