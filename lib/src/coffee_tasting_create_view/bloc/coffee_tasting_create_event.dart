part of 'coffee_tasting_create_bloc.dart';

@immutable
abstract class CoffeeTastingCreateEvent {}

class InsertCoffeeTastingEvent extends CoffeeTastingCreateEvent {}

class AddCoffeeTastingNoteEvent extends CoffeeTastingCreateEvent {
  @required
  final Note note;
  AddCoffeeTastingNoteEvent({this.note});
}

class RemoveCoffeeTastingNoteEvent extends CoffeeTastingCreateEvent {
  @required
  final Note note;
  RemoveCoffeeTastingNoteEvent({this.note});
}

class CreateCoffeeTastingNoteEvent extends CoffeeTastingCreateEvent {
  @required
  final Note note;
  @required
  final NoteCategory noteCategory;
  CreateCoffeeTastingNoteEvent({this.note, this.noteCategory});
}

class CreateCoffeeTastingNoteCategoryEvent extends CoffeeTastingCreateEvent {
  @required
  final NoteCategory noteCategory;
  CreateCoffeeTastingNoteCategoryEvent({this.noteCategory});
}

class CoffeeNameEvent extends CoffeeTastingCreateEvent {
  @required
  final String coffeeName;
  CoffeeNameEvent({this.coffeeName});
}

class DescriptionEvent extends CoffeeTastingCreateEvent {
  @required
  final String description;
  DescriptionEvent({this.description});
}

class OriginEvent extends CoffeeTastingCreateEvent {
  @required
  final String origin;
  OriginEvent({this.origin});
}

class RoasterEvent extends CoffeeTastingCreateEvent {
  @required
  final String roaster;
  RoasterEvent({this.roaster});
}

class ProcessEvent extends CoffeeTastingCreateEvent {
  @required
  final String process;
  ProcessEvent({this.process});
}

class RoastLevelEvent extends CoffeeTastingCreateEvent {
  @required
  final double roastLevel;
  RoastLevelEvent({this.roastLevel});
}

class AromaScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double aromaScore;
  AromaScoreEvent({this.aromaScore});
}

class AromaIntensityEvent extends CoffeeTastingCreateEvent {
  @required
  final double aromaIntensity;
  AromaIntensityEvent({this.aromaIntensity});
}

class AcidityScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double acidityScore;
  AcidityScoreEvent({this.acidityScore});
}

class AcidityIntensityEvent extends CoffeeTastingCreateEvent {
  @required
  final double acidityIntensity;
  AcidityIntensityEvent({this.acidityIntensity});
}

class BodyScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double bodyScore;
  BodyScoreEvent({this.bodyScore});
}

class BodyLevelEvent extends CoffeeTastingCreateEvent {
  @required
  final double bodyLevel;
  BodyLevelEvent({this.bodyLevel});
}

class SweetnessScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double sweetnessScore;
  SweetnessScoreEvent({this.sweetnessScore});
}

class SweetnessIntensityEvent extends CoffeeTastingCreateEvent {
  @required
  final double sweetnessIntensity;
  SweetnessIntensityEvent({this.sweetnessIntensity});
}

class FinishScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double finishScore;
  FinishScoreEvent({this.finishScore});
}

class FinishDurationEvent extends CoffeeTastingCreateEvent {
  @required
  final double finishDuration;
  FinishDurationEvent({this.finishDuration});
}

class FlavorScoreEvent extends CoffeeTastingCreateEvent {
  @required
  final double flavorScore;
  FlavorScoreEvent({this.flavorScore});
}

class AddImageEvent extends CoffeeTastingCreateEvent {
  @required
  final String imagePath;
  AddImageEvent({this.imagePath});
}
