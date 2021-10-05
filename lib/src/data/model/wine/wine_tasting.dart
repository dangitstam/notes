import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/tasting.dart';
import 'package:notes/src/data/model/wine/characteristic.dart';
import 'package:notes/src/data/model/wine/varietal.dart';

/// A wine tasting containing metadata and personal notes on a wine's qualities.
///
/// This data model is shared by both the remote and local storage solutions for this app.
/// [imageFileName] is only used when dealing with local storage, while [imageUrl] is only used for remote storage.
class WineTasting extends Equatable implements Tasting {
  // Don't forget to update props everytime a new field is added!
  final int wineTastingId;
  final String name;
  final String description;
  final String origin;
  final String winemaker;
  final List<Varietal> varietals;
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

  final List<Characteristic> characteristics;
  final String imageFileName;
  final String imageUrl;

  // Optional story behind the wine, provided by the discovery path to tasting.
  final String story;

  WineTasting({
    this.wineTastingId,
    this.name,
    this.description,
    this.origin,
    this.winemaker,
    this.varietals,
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
    this.characteristics,

    // Image chosen for the tasting.
    this.imageFileName,
    this.imageUrl,

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

      characteristics: tastingMap['characteristics'].map((c) => Characteristic.fromAppDatabase(c)).toList(),

      // Image chosen for the tasting.
      imageFileName: tastingMap['image_file_name'],
      story: tastingMap['story'],
    );
  }

  /// Given a [DocumentSnapshot] of a wine from Firebase, translate into a [WineTasting].
  /// If an image exists for the tasting, the resulting [WineTasting] will only have `"image_url"` populated.
  factory WineTasting.fromDocumentSnapshot(DocumentSnapshot wineDoc) {
    // Collect varietals.
    List<Varietal> varietals = [];
    if (wineDoc.data().containsKey('varietals') && wineDoc['varietals'] is List) {
      for (var varietal in wineDoc['varietals']) {
        var name = varietal['name'];
        var percentage = varietal['percentage'];
        varietals.add(Varietal(name: name, percentage: percentage));
      }
    }

    List<Note> notes = [];
    if (wineDoc.data().containsKey('notes') && wineDoc['notes'] is List) {
      for (var note in wineDoc['notes']) {
        var name = note['name'];
        var color = note['color'];
        var noteId = note['note_id'];
        notes.add(Note(name: name, color: color, id: noteId));
      }
    }

    List<Characteristic> characteristics;
    if (wineDoc.data().containsKey('characteristics') && wineDoc['characteristics'] is List) {
      characteristics = wineDoc['characteristics']
          .map<Characteristic>(
            (c) => Characteristic.fromAppDatabase(c),
          )
          .toList();
    }

    return WineTasting(
      // Metadata.
      name: wineDoc['name'],
      description: wineDoc['description'],
      origin: wineDoc['origin'],
      winemaker: wineDoc['winemaker'],
      alcoholByVolume: wineDoc['alcohol_by_volume'].toDouble(),
      vintage: wineDoc['vintage'],
      wineType: wineDoc['wine_type'],
      bubbles: wineDoc['bubbles'],

      // TODO: Use uid of story document.
      story: wineDoc['story'],

      // Tasting notes
      notes: notes,

      // Vinification
      isBiodynamic: wineDoc['is_biodynamic'],
      isOrganicFarming: wineDoc['is_organic_farming'],
      isUnfinedUnfiltered: wineDoc['is_unfined_unfiltered'],
      isWildYeast: wineDoc['is_wild_yeast'],
      isNoAddedSulfites: wineDoc['is_no_added_sulfites'],
      isEthicallyMade: wineDoc['is_ethically_made'],

      // Grape varietals.
      varietals: varietals,

      // Characteristics.
      acidity: wineDoc['acidity'],
      sweetness: wineDoc['sweetness'],
      tannin: wineDoc['tannin'],
      body: wineDoc['body'],
      imageUrl: wineDoc['image_url'],

      characteristics: characteristics,
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

      // Grape varietals
      'varietals': varietals.map((varietal) => varietal.toMap()).toList(),

      // Tasting notes
      'notes': notes.map((note) => note.toMap()).toList(),

      'alcohol_by_volume': alcoholByVolume,
      'wine_type': wineType,
      'bubbles': bubbles,
      'is_biodynamic': isBiodynamic,
      'is_organic_farming': isOrganicFarming,
      'is_unfined_unfiltered': isUnfinedUnfiltered,
      'is_wild_yeast': isWildYeast,
      'is_no_added_sulfites': isNoAddedSulfites,
      'is_ethically_made': isEthicallyMade,
      'vintage': vintage,
      'acidity': acidity,
      'body': body,
      'sweetness': sweetness,
      'tannin': tannin,
      'characteristics': characteristics.map((c) => c.toMap()).toList(),
      'image_file_name': imageFileName,
      'image_url': imageUrl,
      'story': story,
    };
  }

  /// Converts this [WineTasting] into a map suitable for insertion into SQLite.
  Map<String, dynamic> toSql() {
    // In the SQLite implementation, `notes` and `varietals` are normalized.
    // Should the tasting be converted to a nested map, this would result in each becoming a List<Map<String, Dynamic>>.
    // SQLite will raise an exception when it detects List<Map<String, Dynamic>> as a value of any field in the map.
    // Remove them from the map to prevent the exception.
    //
    // `image_url` is also omitted and will be stored remotely instead.
    return {
      'name': name,
      'description': description,
      'origin': origin,
      'winemaker': winemaker,
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
      'image_file_name': imageFileName,
      'story': story,
    };
  }

  WineTasting copyWith({
    int wineTastingId,
    String name,
    String description,
    String origin,
    String winemaker,
    List<Varietal> varietals,
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
    List<Characteristic> characteristics,
    List<Note> notes,
    String imageFileName,
    String imageUrl,
    String story,
  }) {
    return WineTasting(
      wineTastingId: wineTastingId ?? this.wineTastingId,
      name: name ?? this.name,
      description: description ?? this.description,
      origin: origin ?? this.origin,
      winemaker: winemaker ?? this.winemaker,
      varietals: varietals ?? this.varietals,
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
      characteristics: characteristics ?? this.characteristics,
      notes: notes ?? this.notes,
      imageFileName: imageFileName ?? this.imageFileName,
      imageUrl: imageUrl ?? this.imageUrl,
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
        varietals,
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
        characteristics,
        body,
        notes,
        imageFileName,
        imageUrl,
        story,
      ];
}
