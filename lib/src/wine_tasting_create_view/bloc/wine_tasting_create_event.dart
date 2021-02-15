part of 'wine_tasting_create_bloc.dart';

@immutable
abstract class WineTastingCreateEvent {}

class InsertWineTastingEvent extends WineTastingCreateEvent {}

class AddWineTastingNoteEvent extends WineTastingCreateEvent {
  @required
  final Note note;
  AddWineTastingNoteEvent({this.note});
}

class RemoveWineTastingNoteEvent extends WineTastingCreateEvent {
  @required
  final Note note;
  RemoveWineTastingNoteEvent({this.note});
}

class CreateWineTastingNoteEvent extends WineTastingCreateEvent {
  @required
  final Note note;
  @required
  final NoteCategory noteCategory;
  CreateWineTastingNoteEvent({this.note, this.noteCategory});
}

class CreateWineTastingNoteCategoryEvent extends WineTastingCreateEvent {
  @required
  final NoteCategory noteCategory;
  CreateWineTastingNoteCategoryEvent({this.noteCategory});
}

class NameEvent extends WineTastingCreateEvent {
  @required
  final String name;
  NameEvent({this.name});
}

class DescriptionEvent extends WineTastingCreateEvent {
  @required
  final String description;
  DescriptionEvent({this.description});
}

class OriginEvent extends WineTastingCreateEvent {
  @required
  final String origin;
  OriginEvent({this.origin});
}

class RoasterEvent extends WineTastingCreateEvent {
  @required
  final String roaster;
  RoasterEvent({this.roaster});
}

class ProcessEvent extends WineTastingCreateEvent {
  @required
  final String process;
  ProcessEvent({this.process});
}

class RoastLevelEvent extends WineTastingCreateEvent {
  @required
  final double roastLevel;
  RoastLevelEvent({this.roastLevel});
}

class AddWineVarietalNamesEvent extends WineTastingCreateEvent {
  @required
  final String varietalNames;
  AddWineVarietalNamesEvent({this.varietalNames});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AddWineVarietalNamesEvent && other.varietalNames == varietalNames;
  }
}

class AddWineVarietalPercentagesEvent extends WineTastingCreateEvent {
  @required
  final String varietalPercentages;
  AddWineVarietalPercentagesEvent({this.varietalPercentages});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is AddWineVarietalPercentagesEvent && other.varietalPercentages == varietalPercentages;
  }
}

class AddAlcoholByVolumeEvent extends WineTastingCreateEvent {
  @required
  final double alcoholByVolume;
  AddAlcoholByVolumeEvent({this.alcoholByVolume});
}

/// Enter: Characteristics.
class AromaScoreEvent extends WineTastingCreateEvent {
  @required
  final double aromaScore;
  AromaScoreEvent({this.aromaScore});
}

class AromaIntensityEvent extends WineTastingCreateEvent {
  @required
  final double aromaIntensity;
  AromaIntensityEvent({this.aromaIntensity});
}

class AcidityScoreEvent extends WineTastingCreateEvent {
  @required
  final double acidityScore;
  AcidityScoreEvent({this.acidityScore});
}

class AcidityIntensityEvent extends WineTastingCreateEvent {
  @required
  final double acidityIntensity;
  AcidityIntensityEvent({this.acidityIntensity});
}

class BodyScoreEvent extends WineTastingCreateEvent {
  @required
  final double bodyScore;
  BodyScoreEvent({this.bodyScore});
}

class BodyLevelEvent extends WineTastingCreateEvent {
  @required
  final double bodyLevel;
  BodyLevelEvent({this.bodyLevel});
}

class SweetnessScoreEvent extends WineTastingCreateEvent {
  @required
  final double sweetnessScore;
  SweetnessScoreEvent({this.sweetnessScore});
}

class SweetnessIntensityEvent extends WineTastingCreateEvent {
  @required
  final double sweetnessIntensity;
  SweetnessIntensityEvent({this.sweetnessIntensity});
}

class FinishScoreEvent extends WineTastingCreateEvent {
  @required
  final double finishScore;
  FinishScoreEvent({this.finishScore});
}

class FinishDurationEvent extends WineTastingCreateEvent {
  @required
  final double finishDuration;
  FinishDurationEvent({this.finishDuration});
}

/// Exit: Characteristics.

class FlavorScoreEvent extends WineTastingCreateEvent {
  @required
  final double flavorScore;
  FlavorScoreEvent({this.flavorScore});
}

class AddImageEvent extends WineTastingCreateEvent {
  @required
  final String imagePath;
  AddImageEvent({this.imagePath});
}
