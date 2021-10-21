import 'package:equatable/equatable.dart';

class CustomSlider extends Equatable {
  final int id;
  final String name;
  final String minLabel;
  final String maxLabel;

  CustomSlider({this.id, this.name, this.minLabel, this.maxLabel});

  @override
  String toString() {
    return '$name $minLabel $maxLabel';
  }

  /// Given a Map<String, dynamic> resulting from querying a slider
  /// from the `sliders` table, maps the result to a Note.
  factory CustomSlider.fromAppDatabase(Map<String, dynamic> sliderMap) {
    return CustomSlider(
      id: sliderMap['slider_id'],
      name: sliderMap['name'],
      minLabel: sliderMap['left_label'],
      maxLabel: sliderMap['right_label'],
    );
  }

  /// Creates a map representation of this slider fit for insertion into the `sliders` table.
  Map<String, dynamic> toMap() {
    return {
      'slider_id': id,
      'name': name,
      'left_label': minLabel,
      'right_label': maxLabel,
    };
  }

  @override
  List<Object> get props => [id, name, minLabel, maxLabel];
}
