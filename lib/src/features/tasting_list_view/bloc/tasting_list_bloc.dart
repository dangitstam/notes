import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/tasting.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/data/note_repository.dart';
import 'package:notes/src/data/wine_tasting_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'tasting_list_event.dart';
part 'tasting_list_state.dart';

class TastingListBloc extends Bloc<TastingListEvent, TastingListState> {
  TastingListBloc() : super(TastingListState()) {
    // Initialize the stream of past coffee tastings.
    refreshTastingsStream();
  }

  final coffeeTastingRepository = CoffeeTastingRepository();
  final wineTastingRepository = WineTastingRepository();
  final notesRepository = NoteRepository();

  Future<List<WineTasting>> _filteredWineTastings(TastingListState state) async {
    var wineTastings = await wineTastingRepository.getWineTastings();

    return wineTastings.where((e) {
      return e.toMap().toString().contains(state.keywordSearchTerm);
    }).toList();
  }

  @override
  Stream<TastingListState> mapEventToState(
    TastingListEvent event,
  ) async* {
    // Always yield default state.
    // If a filter event comes in, filter the state. (or sort, or whatever)
    // Otherwise get and yield everything.
    //
    // State should reflect which filters, sorts, and searches are being placed.
    if (event is InitTastings) {
      // TODO: Deprecate coffee, it deserves its own app.
      refreshWineTastingsStream();
      yield TastingListState();
    } else if (event is FilterBySearchTermEvent) {
      // Filter tastings by whether they contain the note.
      // 1. Retrieve all the wine tastings that are currently being streamed.
      var newState = state.copyWith(keywordSearchTerm: event.keywordSearchTerm);

      // 2. Apply the newly-added filter.
      var filteredWineTastings = await _filteredWineTastings(newState);

      // Update the wine tastings output stream so subscribing pages can update.
      if (!listEquals(_getWineTastingsController.value, filteredWineTastings)) {
        _inWineTastings.add(filteredWineTastings);
      }

      yield newState;
    }
  }

  // Controller: Page <- App Database.
  final _getCoffeeTastingsController = BehaviorSubject<List<CoffeeTasting>>();
  final _getWineTastingsController = BehaviorSubject<List<WineTasting>>();
  final _getTastingsController = BehaviorSubject<List<Tasting>>();

  // Stream: In
  // Purpose: Update stream that pages subscribe to.
  StreamSink<List<CoffeeTasting>> get _inCoffeeTastings => _getCoffeeTastingsController.sink;
  StreamSink<List<WineTasting>> get _inWineTastings => _getWineTastingsController.sink;
  StreamSink<List<Tasting>> get _inTastings => _getTastingsController.sink;

  void refreshCoffeeTastingsStream() async {
    // Retrieve all the coffee tastings from the database.
    var coffeeTastings = await coffeeTastingRepository.getCoffeeTastings();

    // Update the coffee tastings output stream so subscribing pages can update.
    _inCoffeeTastings.add(coffeeTastings);
  }

  void refreshWineTastingsStream() async {
    // Retrieve all the wine tastings from the database.
    var wineTastings = await wineTastingRepository.getWineTastings();

    // Update the wine tastings output stream so subscribing pages can update.
    _inWineTastings.add(wineTastings);
  }

  void refreshTastingsStream() async {
    // Retrieve all the coffee tastings from the database.
    List<Tasting> coffeeTastings = await coffeeTastingRepository.getCoffeeTastings();

    // Retrieve all the wine tastings from the database.
    List<Tasting> wineTastings = await wineTastingRepository.getWineTastings();

    // List of mixed types is possible, but breaks when attempting to add a new type to a list of a single type
    // constructed with a comprehension, or when attempting to combine lists with `+`.
    // Use loops as a workaround.
    List<Tasting> allTastings = [];
    for (var coffeeTasting in coffeeTastings) {
      allTastings.add(coffeeTasting);
    }
    for (var wineTasting in wineTastings) {
      allTastings.add(wineTasting);
    }

    _inTastings.add(allTastings);
  }

  // Stream: out.
  // Purpose: Stream that other pages subscribe to for coffee tastings.
  Stream<List<CoffeeTasting>> get coffeeTastings => _getCoffeeTastingsController.stream;
  Stream<List<WineTasting>> get wineTastings => _getWineTastingsController.stream;
  Stream<List<Tasting>> get tastings => _getTastingsController.stream;

  @override
  Future<void> close() {
    _getCoffeeTastingsController.close();
    _getWineTastingsController.close();
    _getTastingsController.close();
    return super.close();
  }
}
