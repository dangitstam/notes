import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/tasting.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/data/wine_tasting_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'coffee_tasting_list_event.dart';
part 'coffee_tasting_list_state.dart';

class CoffeeTastingListBloc extends Bloc<TastingListEvent, TastingListState> {
  CoffeeTastingListBloc() : super(TastingListInitialized()) {
    // Initialize the stream of past coffee tastings.
    refreshCoffeeTastingsStream();
  }

  final coffeeTastingRepository = CoffeeTastingRepository();
  final wineTastingRepository = WineTastingRepository();

  @override
  Stream<TastingListState> mapEventToState(
    TastingListEvent event,
  ) async* {
    // TODO: implement mapEventToState
    // Always yield default state.
    // If a filter event comes in, filter the state. (or sort, or whatever)
    // Otherwise get and yield everything.
    //
    // State should reflect which filters, sorts, and searches are being placed.
    if (event is InitTastings) {
      refreshAllTastings();
      yield TastingListInitialized();
    }
  }

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController = BehaviorSubject<List<CoffeeTasting>>();
  final _getWineTastingsController = BehaviorSubject<List<WineTasting>>();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings => _getCoffeeTastingsController.sink;
  StreamSink<List<WineTasting>> get _inWineTastings => _getWineTastingsController.sink;

  void refreshCoffeeTastingsStream() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await coffeeTastingRepository.getCoffeeTastings();

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  void refreshWineTastingsStream() async {
    // Retrieve all the wine tastings from the database.
    var wineTastings = await wineTastingRepository.getWineTastings();

    // Update the coffee tastings output stream so subscribing pages can update.
    _inWineTastings.add(wineTastings);
  }

  void refreshAllTastings() {
    refreshCoffeeTastingsStream();
    refreshWineTastingsStream();
  }

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings => _getCoffeeTastingsController.stream;
  Stream<List<WineTasting>> get wineTastings => _getWineTastingsController.stream;
  Stream<List<Tasting>> get tastings => Rx.merge(
        [
          coffeeTastings,
          wineTastings,
        ],
      );

  @override
  Future<void> close() {
    _getCoffeeTastingsController.close();
    return super.close();
  }
}
