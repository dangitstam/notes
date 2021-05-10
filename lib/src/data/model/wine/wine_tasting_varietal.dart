import 'package:equatable/equatable.dart';

/// Associates wines with their varietals.
/// Includes a percentage of how much the wine is made up from this varietal.
/// TODO: Is this even needed?
class WineTastingVarietal extends Equatable {
  final int varietal_id;
  final String wine_tasting_id;
  final int percentage;

  WineTastingVarietal({this.varietal_id, this.wine_tasting_id, this.percentage});

  factory WineTastingVarietal.fromAppDatabase(Map<String, dynamic> wineTastingNoteMap) {
    return WineTastingVarietal(
      varietal_id: wineTastingNoteMap['varietal_id'],
      wine_tasting_id: wineTastingNoteMap['wine_tasting_id'],
      percentage: wineTastingNoteMap['percentage'],
    );
  }

  WineTastingVarietal copyWith({int varietal_id, String wine_tasting_id, int percentage}) {
    return WineTastingVarietal(
      varietal_id: varietal_id ?? this.varietal_id,
      wine_tasting_id: wine_tasting_id ?? this.wine_tasting_id,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'varietal_id': varietal_id,
      'wine_tasting_id': wine_tasting_id,
      'percentage': percentage,
    };
  }

  @override
  List<Object> get props => [varietal_id, wine_tasting_id, percentage];
}
