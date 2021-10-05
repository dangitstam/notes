import 'package:equatable/equatable.dart';

class CustomSlider extends Equatable {
  final int id;
  final String name;
  final String minLabel;
  final String maxLabel;
  final double min_value;
  final double max_value;

  CustomSlider({this.id, this.name, this.minLabel, this.maxLabel, this.min_value, this.max_value});

  @override
  String toString() {
    return '$name $minLabel $maxLabel $min_value $max_value';
  }

  /// Given a Map<String, dynamic> resulting from querying a note
  /// from the `notes` table, maps the result to a Note.
  factory CustomSlider.fromAppDatabase(Map<String, dynamic> sliderMap) {
    return CustomSlider(
      id: sliderMap['slider_id'],
      name: sliderMap['name'],
      minLabel: sliderMap['left_label'],
      maxLabel: sliderMap['right_label'],
      min_value: sliderMap['min_value'],
      max_value: sliderMap['max_value'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'slider_id': id,
      'name': name,
      'left_label': minLabel,
      'right_label': maxLabel,
      'min_value': min_value,
      'max_value': max_value,
    };
  }

  @override
  List<Object> get props => [id, name, minLabel, maxLabel, min_value, max_value];
}
