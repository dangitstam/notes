import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:notes/src/data/coffee_tasting_repository.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/notes_repository.dart';

part 'coffee_tasting_create_event.dart';
part 'coffee_tasting_create_state.dart';

class CoffeeTastingCreateBloc extends Bloc<CoffeeTastingCreateEvent, CoffeeTastingCreateState> {
  final coffeeTastingRepository = CoffeeTastingRepository();

  final noteBloc = NoteBloc();

  CoffeeTastingCreateBloc()
      : super(
          CoffeeTastingCreateState(
            isCoffeeTastingInserted: false,
            coffeeName: 'I AM A TEST STATE!',
            description: '',
            origin: '',
            roaster: '',
            process: 'Washed',
            roastLevel: 7.0,
            acidityScore: 7.0,
            acidityIntensity: 7.0,
            aftertasteScore: 7.0,
            bodyScore: 7.0,
            bodyLevel: 7.0,
            flavorScore: 7.0,
            fragranceScore: 7.0,
            fragranceBreak: 7.0,
            fragranceDry: 7.0,
          ),
        );

  Future<int> insertCoffeeTasting() async {
    final coffeeTastingId = await coffeeTastingRepository.insert(CoffeeTasting(
        coffeeName: state.coffeeName,
        description: state.description,
        origin: state.origin,
        process: state.process,
        roaster: state.roaster,
        // TODO: Where should the normalization take place?
        roastLevel: state.roastLevel / 10,
        acidity: state.acidityScore,
        aftertaste: state.aftertasteScore,
        body: state.bodyScore,
        flavor: state.flavorScore,
        fragrance: state.fragranceScore));

    return coffeeTastingId;
  }

  @override
  Stream<CoffeeTastingCreateState> mapEventToState(
    CoffeeTastingCreateEvent event,
  ) async* {
    if (event is InsertCoffeeTastingEvent) {
      // Reflect in state whether the tasting was successfully inserted.
      var coffeeTastingId = await insertCoffeeTasting();
      yield state.copyWith(isCoffeeTastingInserted: coffeeTastingId > 0);
    } else if (event is CoffeeNameEvent) {
      yield state.copyWith(coffeeName: event.coffeeName);
    } else if (event is DescriptionEvent) {
      yield state.copyWith(description: event.description);
    } else if (event is OriginEvent) {
      yield state.copyWith(origin: event.origin);
    } else if (event is RoasterEvent) {
      yield state.copyWith(roaster: event.roaster);
    } else if (event is RoastLevelEvent) {
      yield state.copyWith(roastLevel: event.roastLevel);
    } else if (event is ProcessEvent) {
      yield state.copyWith(process: event.process);
    } else if (event is AcidityScoreEvent) {
      yield state.copyWith(acidityScore: event.acidityScore);
    } else if (event is AcidityIntensityEvent) {
      yield state.copyWith(acidityIntensity: event.acidityIntensity);
    } else if (event is AftertasteScoreEvent) {
      yield state.copyWith(aftertasteScore: event.aftertasteScore);
    } else if (event is BodyScoreEvent) {
      yield state.copyWith(bodyScore: event.bodyScore);
    } else if (event is BodyLevelEvent) {
      yield state.copyWith(bodyLevel: event.bodyLevel);
    } else if (event is FlavorScoreEvent) {
      yield state.copyWith(flavorScore: event.flavorScore);
    } else if (event is FragranceScoreEvent) {
      yield state.copyWith(fragranceScore: event.fragranceScore);
    } else if (event is FragranceBreakEvent) {
      yield state.copyWith(fragranceBreak: event.fragranceBreak);
    } else if (event is FragranceDryEvent) {
      yield state.copyWith(fragranceDry: event.fragranceDry);
    }
  }
}
