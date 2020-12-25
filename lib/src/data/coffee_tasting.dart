import 'dart:convert' show json;

class CoffeeTasting {
  final int id;
  final String coffee_name;
  final String description;
  final String origin;
  final String process;
  final String roaster;
  final List<String> notes;
  final double roast_level;

  final double acidity;
  final double aftertaste;
  final double body;
  final double flavor;
  final double fragrance;

  CoffeeTasting(
      {this.id,
      this.coffee_name,
      this.description,
      this.origin,
      this.process,
      this.roaster,
      this.notes,
      this.roast_level,
      this.acidity,
      this.aftertaste,
      this.body,
      this.flavor,
      this.fragrance});

  /// Given a Map<String, dynamic> resulting from querying a coffee tasting
  /// from the `coffee_tastings` table, maps the result to a CoffeeTasting.
  factory CoffeeTasting.fromAppDatabase(Map<String, dynamic> tastingMap) {
    return CoffeeTasting(
        coffee_name: tastingMap['coffee_name'],
        description: tastingMap['description'],
        origin: tastingMap['origin'],
        process: tastingMap['process'],
        // Notes are stored as a serialized list of strings in the SQLite db.
        notes: List<String>.from(json.decode(tastingMap['notes'])),
        roast_level: tastingMap['roast_level'],
        roaster: tastingMap['roaster'],
        acidity: tastingMap['acidity'],
        aftertaste: tastingMap['aftertaste'],
        body: tastingMap['body'],
        flavor: tastingMap['flavor'],
        fragrance: tastingMap['fragrance']);
  }

  /// Converts this CoffeeTasting into a map.
  /// Invariant: `notes` is stored as a serialized list of strings.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'coffee_name': coffee_name,
      'description': description,
      'origin': origin,
      'process': process,
      'roaster': roaster,
      // Local storage as serialized list of strings.
      'notes': json.encode(notes),
      'roast_level': roast_level,
      'acidity': acidity,
      'aftertaste': aftertaste,
      'body': body,
      'flavor': flavor,
      'fragrance': fragrance
    };
  }
}
