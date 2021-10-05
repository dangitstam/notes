import 'package:equatable/equatable.dart';

class Characteristic extends Equatable {
  final String name;
  final String minLabel;
  final String maxLabel;
  final double value;

  Characteristic({
    this.name,
    this.minLabel,
    this.maxLabel,
    this.value,
  });

  @override
  String toString() {
    return toMap().toString();
  }

  Characteristic copyWith({
    String name,
    String minLabel,
    String maxLabel,
    double value,
  }) {
    return Characteristic(
      name: name ?? this.name,
      minLabel: minLabel ?? this.minLabel,
      maxLabel: maxLabel ?? this.maxLabel,
      value: value ?? this.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'minLabel': minLabel,
      'maxLabel': maxLabel,
      'value': value,
    };
  }

  factory Characteristic.fromAppDatabase(Map<String, dynamic> characteristicMap) {
    return Characteristic(
      name: characteristicMap['name'],
      minLabel: characteristicMap['minLabel'],
      maxLabel: characteristicMap['maxLabel'],
      value: characteristicMap['value'],
    );
  }

  @override
  List<Object> get props => [
        name,
        minLabel,
        maxLabel,
        value,
      ];
}
