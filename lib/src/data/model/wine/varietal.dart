class Varietal {
  final String name;
  final int percentage;

  Varietal({this.name, this.percentage});

  factory Varietal.fromAppDatabase(Map<String, dynamic> wineTastingNoteMap) {
    return Varietal(
      name: wineTastingNoteMap['name'],
      percentage: wineTastingNoteMap['percentage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'percentage': percentage,
    };
  }
}
