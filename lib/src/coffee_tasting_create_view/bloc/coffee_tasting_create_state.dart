part of 'coffee_tasting_create_bloc.dart';

@immutable
class CoffeeTastingCreateState extends Equatable {
  final bool isCoffeeTastingInserted;
  final String coffeeName;
  final String description;
  final String origin;
  final String roaster;
  final String process;
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

  final List<Note> notes;

  CoffeeTastingCreateState({
    this.isCoffeeTastingInserted,
    this.coffeeName,
    this.description,
    this.origin,
    this.roaster,
    this.process,
    this.roastLevel,
    this.acidityScore,
    this.acidityIntensity,
    this.bodyScore,
    this.bodyLevel,
    this.aromaScore,
    this.aromaIntensity,
    this.sweetnessScore,
    this.sweetnessIntensity,
    this.finishScore,
    this.finishDuration,
    this.flavorScore,
    this.notes,
    this.imagePath,
  });

  CoffeeTastingCreateState copyWith({
    bool isCoffeeTastingInserted,
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
    double flavorScore,
    double aromaScore,
    double aromaIntensity,
    double sweetnessScore,
    double sweetnessIntensity,
    double finishScore,
    double finishDuration,
    List<Note> notes,
    String imagePath,
  }) {
    return CoffeeTastingCreateState(
      isCoffeeTastingInserted: isCoffeeTastingInserted ?? this.isCoffeeTastingInserted,
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
        isCoffeeTastingInserted,
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
