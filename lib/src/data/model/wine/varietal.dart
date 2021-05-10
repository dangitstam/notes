import 'package:equatable/equatable.dart';

class Varietal extends Equatable {
  final String name;
  final int percentage;

  Varietal({this.name, this.percentage});

  factory Varietal.fromAppDatabase(Map<String, dynamic> wineTastingNoteMap) {
    return Varietal(
      name: wineTastingNoteMap['name'],
      percentage: wineTastingNoteMap['percentage'],
    );
  }

  Varietal copyWith({String name, int percentage}) {
    return Varietal(
      name: name ?? this.name,
      percentage: percentage ?? this.percentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'percentage': percentage,
    };
  }

  @override
  List<Object> get props => [name, percentage];
}
