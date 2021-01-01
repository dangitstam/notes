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
    if (event is AcidityScoreEvent) {
      yield state.copyWith(acidityScore: event.acidityScore);
    } else if (event is AcidityIntensityEvent) {
      yield state.copyWith(acidityIntensity: event.acidityIntensity);
    } else if (event is AftertasteScoreEvent) {
      yield state.copyWith(aftertasteScore: event.aftertasteScore);
    }
  }
}
