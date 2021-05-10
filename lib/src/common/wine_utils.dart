import 'package:notes/src/data/model/wine/wine_tasting.dart';

/// Given a wine tasting, creates a comma-separated string of percent and varietal pairs.
///
/// E.g. "80% Grenache, 20% Mourvèdre".
/// Returns an empty string for malformed tastings.
String formatVarietals(WineTasting tasting) {
  if (tasting.varietals.isNotEmpty) {
    List<String> res = [];

    for (var varietal in tasting.varietals) {
      final String varietalName = varietal.name;
      final String varietalPercentage = varietal.percentage.toString();
      final String formattedVarietal = '$varietalPercentage% $varietalName';
      res.add(formattedVarietal);
    }

    return res.join(', ');
  }

  return '';
}

/// Given a wine tasting, returns a list of strings of the wine's production facts.
///
/// E.g. ["Biodynamic", "Organic Farming", "Wild Yeast"].
List<String> formatVinification(WineTasting tasting) {
  List<String> vinificationFacts = [];
  if (tasting.isBiodynamic) {
    vinificationFacts.add('Biodynamic');
  }
  if (tasting.isOrganicFarming) {
    vinificationFacts.add('Organic Farming');
  }
  if (tasting.isUnfinedUnfiltered) {
    vinificationFacts.add('Unfined & Unfiltered');
  }
  if (tasting.isWildYeast) {
    vinificationFacts.add('Wild Yeast');
  }
  if (tasting.isNoAddedSulfites) {
    vinificationFacts.add('No Added S02');
  }
  if (tasting.isEthicallyMade) {
    vinificationFacts.add('Ethically Made');
  }
  return vinificationFacts;
}
