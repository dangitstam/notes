part of 'wine_tasting_create_bloc.dart';

@immutable
class WineTastingCreateState extends Equatable {
  final bool isWineTastingInserted;
  final WineTasting tasting;
  final PickedFile pickedImage;

  WineTastingCreateState({
    this.isWineTastingInserted,
    this.tasting,
    this.pickedImage,
  });

  WineTastingCreateState copyWith({
    bool isWineTastingInserted,
    WineTasting tasting,

    // Local image path stored separately; the tasting will contain the cloud storage URL.
    PickedFile pickedImage,
  }) {
    return WineTastingCreateState(
      isWineTastingInserted: isWineTastingInserted ?? this.isWineTastingInserted,
      tasting: tasting ?? this.tasting,
      pickedImage: pickedImage ?? this.pickedImage,
    );
  }

  @override
  List<Object> get props => [
        isWineTastingInserted,
        tasting,
      ];
}
