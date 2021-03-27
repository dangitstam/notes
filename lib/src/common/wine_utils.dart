import 'dart:convert';

import 'package:notes/src/data/model/wine/wine_tasting.dart';

/// Given a wine tasting, creates a comma-separated string of percent and varietal pairs.
///
/// E.g. "80% Grenache, 20% Mourvèdre".
/// Returns an empty string for malformed tastings.
String formatVarietals(WineTasting tasting) {
  if (tasting.varietalNames.isNotEmpty && tasting.varietalPercentages.isNotEmpty) {
    List<String> varietals = json.decode(tasting.varietalNames).cast<String>();
    List<int> varietalPercentages = json.decode(tasting.varietalPercentages).cast<int>();
    if (varietals.length == varietalPercentages.length) {
      List<String> res = [];
      for (var i = 0; i < varietals.length; i++) {
        final String varietal = varietals[i];
        final String varietalPercentage = varietalPercentages[i].toString();
        final String formattedVarietal = '$varietalPercentage% $varietal';
        res.add(formattedVarietal);
      }

      return res.join(', ');
    }
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
