part of 'coffee_tasting_create_bloc.dart';

@immutable
abstract class CoffeeTastingCreateEvent {}

class InsertCoffeeTastingEvent extends CoffeeTastingCreateEvent {}

class AddCoffeeTastingNoteEvent extends CoffeeTastingCreateEvent {
  final Note note;
  AddCoffeeTastingNoteEvent({this.note});
}

class RemoveCoffeeTastingNoteEvent extends CoffeeTastingCreateEvent {
  final Note note;
  RemoveCoffeeTastingNoteEvent({this.note});
}

class CoffeeNameEvent extends CoffeeTastingCreateEvent {
  final String coffeeName;
  CoffeeNameEvent({this.coffeeName});
}

class DescriptionEvent extends CoffeeTastingCreateEvent {
  final String description;
  DescriptionEvent({this.description});
}

class OriginEvent extends CoffeeTastingCreateEvent {
  final String origin;
  OriginEvent({this.origin});
}

class RoasterEvent extends CoffeeTastingCreateEvent {
  final String roaster;
  RoasterEvent({this.roaster});
}

class ProcessEvent extends CoffeeTastingCreateEvent {
  final String process;
  ProcessEvent({this.process});
}

class RoastLevelEvent extends CoffeeTastingCreateEvent {
  final double roastLevel;
  RoastLevelEvent({this.roastLevel});
}

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

class AddImageEvent extends CoffeeTastingCreateEvent {
  final String imagePath;
  AddImageEvent({this.imagePath});
}
