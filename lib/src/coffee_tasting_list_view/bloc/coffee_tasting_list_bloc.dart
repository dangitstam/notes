import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/app_database.dart';

import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/dao/coffee_tasting_dao.dart';
import 'package:notes/src/data/dao/coffee_tasting_note_dao.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

part 'coffee_tasting_list_event.dart';
part 'coffee_tasting_list_state.dart';

class CoffeeTastingListBloc extends Bloc<CoffeeTastingListEvent, CoffeeTastingListState> {
  CoffeeTastingListBloc() : super(CoffeeTastingListInitial());

  final coffeeTastingRepository = CoffeeTastingRepository();

  @override
  Stream<CoffeeTastingListState> mapEventToState(
    CoffeeTastingListEvent event,
  ) async* {
    // TODO: implement mapEventToState
    // Always yield default state.
    // If a filter event comes in, filter the state. (or sort, or whatever)
    // Otherwise get and yield everything.
    //
    // State should reflect which filters, sorts, and searches are being placed.
    if (event is InitCoffeeTastingList) {
      getCoffeeTastings();
      yield CoffeeTastingListInitial();
    }
  }

  final CoffeeTastingDao _coffeeTastingDao = CoffeeTastingDao(database: AppDatabase.db.database);

  final CoffeeTastingNoteDao _coffeeTastingNotesDao = CoffeeTastingNoteDao(database: AppDatabase.db.database);

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController = StreamController<List<CoffeeTasting>>.broadcast();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings => _getCoffeeTastingsController.sink;

  void dispose() {
    _getCoffeeTastingsController.close();
  }

  void getCoffeeTastings() async {
    print('getCoffeeTastings II');
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await _coffeeTastingDao.getAllCoffeeTastings();

    // Collect tasting notes for each coffee tasting.
    for (var coffeeTasting in coffeeTastings) {
      final notes = await _coffeeTastingNotesDao.getCoffeeTastingNotes(coffeeTasting.coffeeTastingId);
      coffeeTasting.notes = notes;
    }

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  /// Repository API

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings => _getCoffeeTastingsController.stream;

  Future<int> insert(CoffeeTasting coffeeTasting) async {
    final coffeeTastingId = await coffeeTastingRepository.insert(coffeeTasting);

    // Update output stream on every insertion.
    getCoffeeTastings();

    return coffeeTastingId;
  }
}
