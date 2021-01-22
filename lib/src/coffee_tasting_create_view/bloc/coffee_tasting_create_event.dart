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

class AromaScoreEvent extends CoffeeTastingCreateEvent {
  final double aromaScore;
  AromaScoreEvent({this.aromaScore});
}

class AromaIntensityEvent extends CoffeeTastingCreateEvent {
  final double aromaIntensity;
  AromaIntensityEvent({this.aromaIntensity});
}

class AcidityScoreEvent extends CoffeeTastingCreateEvent {
  final double acidityScore;
  AcidityScoreEvent({this.acidityScore});
}

class AcidityIntensityEvent extends CoffeeTastingCreateEvent {
  final double acidityIntensity;
  AcidityIntensityEvent({this.acidityIntensity});
}

class BodyScoreEvent extends CoffeeTastingCreateEvent {
  final double bodyScore;
  BodyScoreEvent({this.bodyScore});
}

class BodyLevelEvent extends CoffeeTastingCreateEvent {
  final double bodyLevel;
  BodyLevelEvent({this.bodyLevel});
}

class SweetnessScoreEvent extends CoffeeTastingCreateEvent {
  final double sweetnessScore;
  SweetnessScoreEvent({this.sweetnessScore});
}

class SweetnessIntensityEvent extends CoffeeTastingCreateEvent {
  final double sweetnessIntensity;
  SweetnessIntensityEvent({this.sweetnessIntensity});
}

class FinishScoreEvent extends CoffeeTastingCreateEvent {
  final double finishScore;
  FinishScoreEvent({this.finishScore});
}

class FinishDurationEvent extends CoffeeTastingCreateEvent {
  final double finishDuration;
  FinishDurationEvent({this.finishDuration});
}

class FlavorScoreEvent extends CoffeeTastingCreateEvent {
  final double flavorScore;
  FlavorScoreEvent({this.flavorScore});
}

class AddImageEvent extends CoffeeTastingCreateEvent {
  final String imagePath;
  AddImageEvent({this.imagePath});
}
