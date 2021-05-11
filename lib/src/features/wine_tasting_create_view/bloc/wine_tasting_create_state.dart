part of 'wine_tasting_create_bloc.dart';

@immutable
class WineTastingCreateState extends Equatable {
  final bool isWineTastingInserted;
  final WineTasting tasting;
  final File pickedImage;

  WineTastingCreateState({
    this.isWineTastingInserted,
    this.tasting,
    this.pickedImage,
  });

  WineTastingCreateState copyWith({
    bool isWineTastingInserted, // An observable signal to widgets whether a tasting has been submitted and saved.
    WineTasting tasting,
    File pickedImage, // File containing the image for the wine tasting.
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
