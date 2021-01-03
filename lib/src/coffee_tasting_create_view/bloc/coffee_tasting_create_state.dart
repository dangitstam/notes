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
  final double acidityScore;
  final double acidityIntensity;
  final double aftertasteScore;
  final double bodyScore;
  final double bodyLevel;
  final double flavorScore;
  final double fragranceScore;
  final double fragranceBreak;
  final double fragranceDry;

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
    this.aftertasteScore,
    this.bodyScore,
    this.bodyLevel,
    this.flavorScore,
    this.fragranceScore,
    this.fragranceBreak,
    this.fragranceDry,
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
    double aftertasteScore,
    double bodyScore,
    double bodyLevel,
    double flavorScore,
    double fragranceScore,
    double fragranceBreak,
    double fragranceDry,
  }) {
    return CoffeeTastingCreateState(
      isCoffeeTastingInserted: isCoffeeTastingInserted ?? this.isCoffeeTastingInserted,
      coffeeName: coffeeName ?? this.coffeeName,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      roaster: roaster ?? this.roaster,
      process: process ?? this.process,
      roastLevel: roastLevel ?? this.roastLevel,
      acidityScore: acidityScore ?? this.acidityScore,
      acidityIntensity: acidityIntensity ?? this.acidityIntensity,
      aftertasteScore: aftertasteScore ?? this.aftertasteScore,
      bodyScore: bodyScore ?? this.bodyScore,
      bodyLevel: bodyLevel ?? this.bodyLevel,
      flavorScore: flavorScore ?? this.flavorScore,
      fragranceScore: fragranceScore ?? this.fragranceScore,
      fragranceBreak: fragranceBreak ?? this.fragranceBreak,
      fragranceDry: fragranceDry ?? this.fragranceDry,
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
        acidityScore,
        acidityIntensity,
        aftertasteScore,
        bodyScore,
        bodyLevel,
        flavorScore,
        fragranceScore,
        fragranceBreak,
        fragranceDry,
      ];
}
