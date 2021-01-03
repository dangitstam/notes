import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

part 'coffee_tasting_list_event.dart';
part 'coffee_tasting_list_state.dart';

class CoffeeTastingListBloc extends Bloc<CoffeeTastingListEvent, CoffeeTastingListState> {
  CoffeeTastingListBloc() : super(CoffeeTastingListInitial()) {
    // Initialize the stream of past coffee tastings.
    getCoffeeTastings();
  }

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

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController = StreamController<List<CoffeeTasting>>.broadcast();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings => _getCoffeeTastingsController.sink;

  void dispose() {
    _getCoffeeTastingsController.close();
  }

  void getCoffeeTastings() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await coffeeTastingRepository.getCoffeeTastings();

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings => _getCoffeeTastingsController.stream;
}
