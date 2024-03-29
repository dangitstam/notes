import 'package:equatable/equatable.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/tasting.dart';

class CoffeeTasting extends Equatable implements Tasting {
  final int coffeeTastingId;
  final String coffeeName;
  final String description;
  final String origin;
  final String process;
  final String roaster;
  final List<Note> notes;
  final double roastLevel;

  final double aromaScore;
  final double aromaIntensity;
  final double acidityScore;
  final double acidityIntensity;
  final double bodyScore;
  final double bodyLevel;
  final double sweetnessScore;
  final double sweetnessIntensity;
  final double finishScore;
  final double finishDuration;

  final double flavorScore;

  final String imagePath;

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

  CoffeeTasting copyWith({
    int coffeeTastingId,
    String coffeeName,
    String description,
    String origin,
    String roaster,
    String process,
    double roastLevel,
    double acidityScore,
    double acidityIntensity,
    double bodyScore,
    double bodyLevel,
    double aromaScore,
    double aromaIntensity,
    double sweetnessScore,
    double sweetnessIntensity,
    double finishScore,
    double finishDuration,
    double flavorScore,
    List<Note> notes,
    String imagePath,
  }) {
    return CoffeeTasting(
      coffeeTastingId: coffeeTastingId ?? this.coffeeTastingId,
      coffeeName: coffeeName ?? this.coffeeName,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      roaster: roaster ?? this.roaster,
      process: process ?? this.process,
      roastLevel: roastLevel ?? this.roastLevel,
      aromaScore: aromaScore ?? this.aromaScore,
      aromaIntensity: aromaIntensity ?? this.aromaIntensity,
      acidityScore: acidityScore ?? this.acidityScore,
      acidityIntensity: acidityIntensity ?? this.acidityIntensity,
      bodyScore: bodyScore ?? this.bodyScore,
      bodyLevel: bodyLevel ?? this.bodyLevel,
      sweetnessScore: sweetnessScore ?? this.sweetnessScore,
      sweetnessIntensity: sweetnessIntensity ?? this.sweetnessIntensity,
      finishScore: finishScore ?? this.finishScore,
      finishDuration: finishDuration ?? this.finishDuration,
      flavorScore: flavorScore ?? this.flavorScore,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  List<Object> get props => [
        coffeeTastingId,
        coffeeName,
        description,
        origin,
        roaster,
        process,
        roastLevel,
        aromaScore,
        aromaIntensity,
        acidityScore,
        acidityIntensity,
        bodyScore,
        bodyLevel,
        flavorScore,
        sweetnessScore,
        sweetnessIntensity,
        finishScore,
        finishDuration,
        notes,
        imagePath,
      ];
}
