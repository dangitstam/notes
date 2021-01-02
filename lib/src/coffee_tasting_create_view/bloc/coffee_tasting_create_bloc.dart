import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'coffee_tasting_create_event.dart';
part 'coffee_tasting_create_state.dart';

class CoffeeTastingCreateBloc extends Bloc<CoffeeTastingCreateEvent, CoffeeTastingCreateState> {
  CoffeeTastingCreateBloc()
      : super(CoffeeTastingCreateState(
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
        ));

  @override
  Stream<CoffeeTastingCreateState> mapEventToState(
    CoffeeTastingCreateEvent event,
  ) async* {
    if (event is CoffeeNameEvent) {
      yield state.copyWith(coffeeName: event.coffeeName);
    } else if (event is DescriptionEvent) {
      yield state.copyWith(description: event.description);
    } else if (event is OriginEvent) {
      yield state.copyWith(origin: event.origin);
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
