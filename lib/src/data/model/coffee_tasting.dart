import 'dart:convert' show json;
import 'package:notes/src/data/model/note.dart';

class CoffeeTasting {
  final int coffeeTastingId;
  String coffeeName;
  String description;
  String origin;
  String process;
  String roaster;
  List<Note> notes;
  double roastLevel;

  double acidity;
  double aftertaste;
  double body;
  double flavor;
  double fragrance;

  CoffeeTasting(
      {this.coffeeTastingId,
      this.coffeeName,
      this.description,
      this.origin,
      this.process,
      this.roaster,
      this.notes = const <Note>[],
      this.roastLevel,
      this.acidity,
      this.aftertaste,
      this.body,
      this.flavor,
      this.fragrance});

  /// Given a Map<String, dynamic> resulting from querying a coffee tasting
  /// from the `coffee_tastings` table, maps the result to a CoffeeTasting.
  factory CoffeeTasting.fromAppDatabase(Map<String, dynamic> tastingMap) {
    return CoffeeTasting(
        coffeeTastingId: tastingMap['coffee_tasting_id'],
        coffeeName: tastingMap['coffee_name'],
        description: tastingMap['description'],
        origin: tastingMap['origin'],
        process: tastingMap['process'],
        roastLevel: tastingMap['roast_level'],
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
    // TODO: Allow the id to be generated for now.
    return {
      'coffee_name': coffeeName,
      'description': description,
      'origin': origin,
      'process': process,
      'roaster': roaster,
      // Local storage as serialized list of strings.
      // 'notes': json.encode(notes),
      'roast_level': roastLevel,
      'acidity': acidity,
      'aftertaste': aftertaste,
      'body': body,
      'flavor': flavor,
      'fragrance': fragrance
    };
  }
}
