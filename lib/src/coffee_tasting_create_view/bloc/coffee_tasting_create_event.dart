part of 'coffee_tasting_create_bloc.dart';

@immutable
abstract class CoffeeTastingCreateEvent {}

class AcidityScoreEvent extends CoffeeTastingCreateEvent {
  final double acidityScore;
  AcidityScoreEvent({this.acidityScore});
}

class AcidityIntensityEvent extends CoffeeTastingCreateEvent {
  final double acidityIntensity;
  AcidityIntensityEvent({this.acidityIntensity});
}

class AftertasteScoreEvent extends CoffeeTastingCreateEvent {
  final double aftertasteScore;
  AftertasteScoreEvent({this.aftertasteScore});
}

class BodyScoreEvent extends CoffeeTastingCreateEvent {
  final double bodyScore;
  BodyScoreEvent({this.bodyScore});
}

class BodyLevelEvent extends CoffeeTastingCreateEvent {
  final double bodyLevel;
  BodyLevelEvent({this.bodyLevel});
}

class FlavorScoreEvent extends CoffeeTastingCreateEvent {
  final double flavorScore;
  FlavorScoreEvent({this.flavorScore});
}

class FragranceScoreEvent extends CoffeeTastingCreateEvent {
  final double fragranceScore;
  FragranceScoreEvent({this.fragranceScore});
}

class FragranceBreakEvent extends CoffeeTastingCreateEvent {
  final double fragranceBreak;
  FragranceBreakEvent({this.fragranceBreak});
}

class FragranceDryEvent extends CoffeeTastingCreateEvent {
  final double fragranceDry;
  FragranceDryEvent({this.fragranceDry});
}
