part of 'wine_tasting_create_bloc.dart';

@immutable
class WineTastingCreateState extends Equatable {
  final bool isWineTastingInserted;

  final WineTasting tasting;

  WineTastingCreateState({
    this.isWineTastingInserted,
    this.tasting,
  });

  WineTastingCreateState copyWith({
    bool isWineTastingInserted,
    WineTasting tasting,
  }) {
    return WineTastingCreateState(
      isWineTastingInserted: isWineTastingInserted ?? this.isWineTastingInserted,
      tasting: tasting ?? this.tasting,
    );
  }

  @override
  List<Object> get props => [
        isWineTastingInserted,
        tasting,
      ];
}
