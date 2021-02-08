part of 'wine_tasting_create_bloc.dart';

@immutable
class WineTastingCreateState extends Equatable {
  final bool isCoffeeTastingInserted;

  final CoffeeTasting tasting;

  WineTastingCreateState({
    this.isCoffeeTastingInserted,
    this.tasting,
  });

  WineTastingCreateState copyWith({
    bool isCoffeeTastingInserted,
    CoffeeTasting tasting,
  }) {
    return WineTastingCreateState(
      isCoffeeTastingInserted: isCoffeeTastingInserted ?? this.isCoffeeTastingInserted,
      tasting: tasting ?? this.tasting,
    );
  }

  @override
  List<Object> get props => [
        isCoffeeTastingInserted,
        tasting,
      ];
}
