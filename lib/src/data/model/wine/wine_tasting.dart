import 'package:equatable/equatable.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/tasting.dart';

class WineTasting extends Equatable implements Tasting {
  final int wineTastingId;
  final String name;
  final String description;
  final String origin;
  final String winemaker;
  final String varietalNames;
  final String varietalPercentages;
  final double alcoholByVolume;
  final String wineType;
  final String bubbles;

  // Vinification.
  final bool isBiodynamic;
  final bool isOrganicFarming;
  final bool isUnfinedUnfiltered;
  final bool isNoAddedSulfites;
  final bool isWildYeast;
  final bool isEthicallyMade;

  final int vintage;
  final List<Note> notes;

  final double acidity;
  final double sweetness;
  final double tannin;
  final double body;

  final String imagePath;

  // Optional story behind the wine, provided by the discovery path to tasting.
  final String story;

  WineTasting({
    this.wineTastingId,
    this.name,
    this.description,
    this.origin,
    this.winemaker,
    this.varietalNames,
    this.varietalPercentages,
    this.alcoholByVolume,
    this.wineType,
    this.bubbles,
    this.isBiodynamic,
    this.isOrganicFarming,
    this.isUnfinedUnfiltered,
    this.isWildYeast,
    this.isNoAddedSulfites,
    this.isEthicallyMade,
    this.vintage,
    this.notes = const <Note>[],

    // Characteristics.
    this.acidity,
    this.sweetness,
    this.tannin,
    this.body,

    // Image path.
    this.imagePath,

    // Story behind the making of the wine.
    this.story,
  });

  /// Given a Map<String, dynamic> resulting from querying a wine tasting
  /// from the `wine_tastings` table, maps the result to a CoffeeTasting.
  factory WineTasting.fromAppDatabase(Map<String, dynamic> tastingMap) {
    return WineTasting(
      wineTastingId: tastingMap['wine_tasting_id'],
      name: tastingMap['name'],
      description: tastingMap['description'],
      origin: tastingMap['origin'],
      winemaker: tastingMap['winemaker'],
      varietalNames: tastingMap['varietal_names'],
      varietalPercentages: tastingMap['varietal_percentages'],
      alcoholByVolume: tastingMap['alcohol_by_volume'],
      wineType: tastingMap['wine_type'],
      bubbles: tastingMap['bubbles'],
      isBiodynamic: tastingMap['is_biodynamic'] == 1,
      isOrganicFarming: tastingMap['is_organic_farming'] == 1,
      isUnfinedUnfiltered: tastingMap['is_unfined_unfiltered'] == 1,
      isWildYeast: tastingMap['is_wild_yeast'] == 1,
      isNoAddedSulfites: tastingMap['is_no_added_sulfites'] == 1,
      isEthicallyMade: tastingMap['is_ethically_made'] == 1,

      vintage: tastingMap['vintage'],

      // Characteristics.
      acidity: tastingMap['acidity'],
      sweetness: tastingMap['sweetness'],
      tannin: tastingMap['tannin'],
      body: tastingMap['body'],

      // Image path
      imagePath: tastingMap['image_path'],

      story: tastingMap['story'],
    );
  }

  /// Converts this CoffeeTasting into a map.
  /// Invariant: `notes` is stored as a serialized list of strings.
  Map<String, dynamic> toMap() {
    // TODO: Allow the id to be generated for now.
    return {
      'name': name,
      'description': description,
      'origin': origin,
      'winemaker': winemaker,
      'varietal_names': varietalNames,
      'varietal_percentages': varietalPercentages,
      'alcohol_by_volume': alcoholByVolume,
      'wine_type': wineType,
      'bubbles': bubbles,
      'is_biodynamic': isBiodynamic ? 1 : 0,
      'is_organic_farming': isOrganicFarming ? 1 : 0,
      'is_unfined_unfiltered': isUnfinedUnfiltered ? 1 : 0,
      'is_wild_yeast': isWildYeast ? 1 : 0,
      'is_no_added_sulfites': isNoAddedSulfites ? 1 : 0,
      'is_ethically_made': isEthicallyMade ? 1 : 0,
      'vintage': vintage,
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'tannin': tannin,
      'image_path': imagePath,
      'story': story,
    };
  }

  WineTasting copyWith({
    int wineTastingId,
    String name,
    String description,
    String origin,
    String winemaker,
    String varietalNames,
    String varietalPercentages,
    double alcoholByVolume,
    String wineType,
    String bubbles,
    bool isBiodynamic,
    bool isOrganicFarming,
    bool isUnfinedUnfiltered,
    bool isWildYeast,
    bool isNoAddedSulfites,
    bool isEthicallyMade,
    int vintage,
    double acidity,
    double sweetness,
    double tannin,
    double body,
    List<Note> notes,
    String imagePath,
    String story,
  }) {
    return WineTasting(
      wineTastingId: wineTastingId ?? this.wineTastingId,
      name: name ?? this.name,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      winemaker: winemaker ?? this.winemaker,
      varietalNames: varietalNames ?? this.varietalNames,
      varietalPercentages: varietalPercentages ?? this.varietalPercentages,
      alcoholByVolume: alcoholByVolume ?? this.alcoholByVolume,
      wineType: wineType ?? this.wineType,
      bubbles: bubbles ?? this.bubbles,
      isBiodynamic: isBiodynamic ?? this.isBiodynamic,
      isOrganicFarming: isOrganicFarming ?? this.isOrganicFarming,
      isUnfinedUnfiltered: isUnfinedUnfiltered ?? this.isUnfinedUnfiltered,
      isWildYeast: isWildYeast ?? this.isWildYeast,
      isNoAddedSulfites: isNoAddedSulfites ?? this.isNoAddedSulfites,
      isEthicallyMade: isEthicallyMade ?? this.isEthicallyMade,
      vintage: vintage ?? this.vintage,
      acidity: acidity ?? this.acidity,
      sweetness: sweetness ?? this.sweetness,
      tannin: tannin ?? this.tannin,
      body: body ?? this.body,
      notes: notes ?? this.notes,
      imagePath: imagePath ?? this.imagePath,
      story: story ?? this.story,
    );
  }

  @override
  List<Object> get props => [
        wineTastingId,
        name,
        description,
        origin,
        winemaker,
        varietalNames,
        varietalPercentages,
        alcoholByVolume,
        wineType,
        bubbles,
        isBiodynamic,
        isOrganicFarming,
        isUnfinedUnfiltered,
        isWildYeast,
        isNoAddedSulfites,
        isEthicallyMade,
        vintage,
        acidity,
        sweetness,
        tannin,
        body,
        notes,
        imagePath,
        story,
      ];
}
