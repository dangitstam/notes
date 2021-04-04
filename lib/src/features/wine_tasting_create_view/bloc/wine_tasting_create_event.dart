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

class AddWinemakerEvent extends WineTastingCreateEvent {
  @required
  final String winemaker;
  AddWinemakerEvent({this.winemaker});
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

class AddWineTypeEvent extends WineTastingCreateEvent {
  @required
  final String wineType;
  AddWineTypeEvent({this.wineType});
}

class AddBubblesEvent extends WineTastingCreateEvent {
  @required
  final String bubbles;
  AddBubblesEvent({this.bubbles});
}

class SetIsBiodynamicEvent extends WineTastingCreateEvent {
  @required
  final bool isBiodynamic;
  SetIsBiodynamicEvent({this.isBiodynamic});
}

class SetIsOrganicFarmingEvent extends WineTastingCreateEvent {
  @required
  final bool isOrganicFarming;
  SetIsOrganicFarmingEvent({this.isOrganicFarming});
}

class SetIsUnfinedUnfilteredEvent extends WineTastingCreateEvent {
  @required
  final bool isUnfinedUnfiltered;
  SetIsUnfinedUnfilteredEvent({this.isUnfinedUnfiltered});
}

class SetIsWildYeastEvent extends WineTastingCreateEvent {
  @required
  final bool isWildYeast;
  SetIsWildYeastEvent({this.isWildYeast});
}

class SetIsNoAddedSulfitesEvent extends WineTastingCreateEvent {
  @required
  final bool isNoAddedSulfites;
  SetIsNoAddedSulfitesEvent({this.isNoAddedSulfites});
}

class SetIsEthicallyMadeEvent extends WineTastingCreateEvent {
  @required
  final bool isEthicallyMade;
  SetIsEthicallyMadeEvent({this.isEthicallyMade});
}

class AddVintageEvent extends WineTastingCreateEvent {
  @required
  final int vintage;
  AddVintageEvent({this.vintage});
}

/// Enter: Characteristics.
class AddAcidityIntensityEvent extends WineTastingCreateEvent {
  @required
  final double acidityIntensity;
  AddAcidityIntensityEvent({this.acidityIntensity});
}

class AddBodyIntensity extends WineTastingCreateEvent {
  @required
  final double bodyIntensity;
  AddBodyIntensity({this.bodyIntensity});
}

class AddSweetnessIntensityEvent extends WineTastingCreateEvent {
  @required
  final double sweetnessIntensity;
  AddSweetnessIntensityEvent({this.sweetnessIntensity});
}

class AddTanninIntensityEvent extends WineTastingCreateEvent {
  @required
  final double tanninIntensity;
  AddTanninIntensityEvent({this.tanninIntensity});
}

/// Exit: Characteristics.

class AddImageEvent extends WineTastingCreateEvent {
  @required
  final String imagePath;
  AddImageEvent({this.imagePath});
}
