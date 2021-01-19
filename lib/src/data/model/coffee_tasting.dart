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

  double aromaScore;
  double aromaIntensity;
  double acidityScore;
  double acidityIntensity;
  double bodyScore;
  double bodyLevel;
  double sweetnessScore;
  double sweetnessIntensity;
  double finishScore;
  double finishDuration;

  double flavorScore;

  String imagePath;

  CoffeeTasting(
      {this.coffeeTastingId,
      this.coffeeName,
      this.description,
      this.origin,
      this.process,
      this.roaster,
      this.notes = const <Note>[],
      this.roastLevel,

      // Characteristics.
      this.aromaScore,
      this.aromaIntensity,
      this.acidityScore,
      this.acidityIntensity,
      this.bodyScore,
      this.bodyLevel,
      this.sweetnessScore,
      this.sweetnessIntensity,
      this.finishScore,
      this.finishDuration,
      this.flavorScore,

      // Image path.
      this.imagePath});

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

      // Characteristics.
      aromaScore: tastingMap['aroma_score'],
      aromaIntensity: tastingMap['aroma_intensity'],
      acidityScore: tastingMap['acidity_score'],
      acidityIntensity: tastingMap['acidity_intensity'],
      bodyScore: tastingMap['body_score'],
      bodyLevel: tastingMap['body_level'],
      sweetnessScore: tastingMap['sweetness_score'],
      sweetnessIntensity: tastingMap['sweetness_intensity'],
      finishScore: tastingMap['finish_score'],
      finishDuration: tastingMap['finish_duration'],
      flavorScore: tastingMap['flavor_score'],

      // Image path
      imagePath: tastingMap['image_path'],
    );
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
      'roast_level': roastLevel,
      'aroma_score': aromaScore,
      'aroma_intensity': aromaIntensity,
      'acidity_score': acidityScore,
      'acidity_intensity': acidityIntensity,
      'body_score': bodyScore,
      'body_level': bodyLevel,
      'sweetness_score': sweetnessScore,
      'sweetness_intensity': sweetnessIntensity,
      'finish_score': finishScore,
      'finish_duration': finishDuration,
      'flavor_score': flavorScore,
      'image_path': imagePath,
    };
  }
}
