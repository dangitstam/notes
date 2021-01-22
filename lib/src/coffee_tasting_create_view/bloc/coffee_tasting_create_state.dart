part of 'coffee_tasting_create_bloc.dart';

@immutable
class CoffeeTastingCreateState extends Equatable {
  final bool isCoffeeTastingInserted;

  final CoffeeTasting tasting;

  CoffeeTastingCreateState({
    this.isCoffeeTastingInserted,
    this.tasting,
  });

  CoffeeTastingCreateState copyWith({
    bool isCoffeeTastingInserted,
    CoffeeTasting tasting,
  }) {
    return CoffeeTastingCreateState(
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
