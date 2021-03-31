import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:readmore/readmore.dart';

class NaturalWineDiscoveryListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black38,
              height: 0.20,
            ),
            preferredSize: Size.fromHeight(0.5)),
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Notes'.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Filter', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Sort', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [
                    Icon(CupertinoIcons.search, color: Colors.black, size: 20),
                    SizedBox(width: 5),
                    Text('Search', style: Theme.of(context).textTheme.caption)
                  ]))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: <Widget>[
                          Text('What are we tasting?'.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                          const SizedBox(height: 40),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Coffee'.toUpperCase()),
                            onPressed: () {
                              // Dismiss the modal before navigating.
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-coffee-tasting');
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Wine'.toUpperCase()),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-wine-tasting');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
      body: NaturalWineDiscoveryListViewWidget(),
    );
  }
}

/// Given a [DocumentSnapshot] of a wine from Firebase, translate into a [WineTasting].
WineTasting fromDocumentSnapshot(DocumentSnapshot wineDoc) {
  // Collect varietals.
  var varietalNames = [];
  var varietalPercentages = [];
  if (wineDoc.data.containsKey('varietals') && wineDoc['varietals'] is List) {
    for (var varietal in wineDoc['varietals']) {
      var name = varietal['name'];
      varietalNames.add(name);

      var percentage = varietal['percentage'];
      varietalPercentages.add(percentage);
    }
  }
  var varietalNamesJsonStr = json.encode(varietalNames);
  var varietalPercentagesJsonStr = json.encode(varietalPercentages);

  return WineTasting(
    name: wineDoc['name'],
    description: '',
    origin: wineDoc['origin'],
    roaster: wineDoc['winemaker'],
    varietalNames: varietalNamesJsonStr,
    varietalPercentages: varietalPercentagesJsonStr,
    alcoholByVolume: wineDoc['alcohol_by_volume'].toDouble(),
    wineType: wineDoc['type'],
    bubbles: '',
    isBiodynamic: wineDoc['is_biodynamic'],
    isOrganicFarming: wineDoc['is_organic_farming'],
    isUnfinedUnfiltered: wineDoc['is_unfined_unfiltered'],
    isWildYeast: wineDoc['is_wild_yeast'],
    isNoAddedSulfites: wineDoc['is_no_added_sulfites'],
    isEthicallyMade: wineDoc['is_ethically_made'],
    vintage: wineDoc['vintage'], // Use a negative value to signal as unspecified.
    process: '',
    roastLevel: 7.0,
    aromaScore: 7.0,
    aromaIntensity: 7.0,
    acidityScore: 7.0,
    acidityIntensity: 7.0,
    bodyScore: 7.0,
    bodyLevel: 7.0,
    sweetnessScore: 7.0,
    sweetnessIntensity: 7.0,
    finishScore: 7.0,
    finishDuration: 7.0,
    flavorScore: 7.0,
    imagePath: null,
  );
}

class NaturalWineDiscoveryListViewWidget extends StatelessWidget {
  NaturalWineDiscoveryListViewWidget({Key key}) : super(key: key);

  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    /**
     * Type (color, bubbles), vintage, alcohol by volume.
     */
    List<String> wineFacts = [];
    String formattedType = document['type'];
    if (document.data.containsKey('bubbles')) {
      formattedType += ' ' + document['bubbles'];
    }
    if (formattedType.isNotEmpty) {
      wineFacts.add(formattedType);
    }

    wineFacts.add(document['vintage'].toString());
    wineFacts.add('Alc. ${document['alcohol_by_volume']}% by vol.');

    String wineFactsText = wineFacts.join(' · ');

    /**
     * Vinification.
     */
    String formattedVinification = '';
    List<String> vinificationFacts = [];
    if (document['is_biodynamic']) {
      vinificationFacts.add('Biodynamic');
    }
    if (document['is_organic_farming']) {
      vinificationFacts.add('Organic Farming');
    }
    if (document['is_unfined_unfiltered']) {
      vinificationFacts.add('Unfined & Unfiltered');
    }
    if (document['is_wild_yeast']) {
      vinificationFacts.add('Wild Yeast');
    }
    if (document['is_no_added_sulfites']) {
      vinificationFacts.add('No Added S02');
    }
    if (document['is_ethically_made']) {
      vinificationFacts.add('Ethically Made');
    }
    if (vinificationFacts.isNotEmpty) {
      formattedVinification = vinificationFacts.join(' · ');
    }

    /**
     * Varietals.
     */
    var varietals = [];
    if (document.data.containsKey('varietals') && document['varietals'] is List) {
      for (var varietal in document['varietals']) {
        var name = varietal['name'];
        int percentage = varietal['percentage'];
        if (percentage != null) {
          varietals.add('$percentage\% $name');
        } else {
          varietals.add(name);
        }
      }
    }

    String formattedVarietals = varietals.join(', ');

    return ListTile(
      contentPadding: EdgeInsets.all(12),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  document['image'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(width: 17),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document['winemaker'].toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 14),
                ),
                Text(
                  document['name'].toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 22),
                ),

                /**
                 * Origin
                 */
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 20,
                      child: AspectRatio(
                        // Icons are rendered in a square container.
                        // Since this icon is taller than it is wide, reflect this as an
                        // aspect ratio to remove the extra horizontal space.
                        aspectRatio: 9.0 / 16.0,
                        child: Icon(CupertinoIcons.location_solid, size: 20, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${document['origin']}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ReadMoreText(
                  document['story'],
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  colorClickableText: Theme.of(context).colorScheme.primary,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  delimiter: ' ... ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                wineFactsText.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          '$wineFactsText',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.end,
                        ),
                      )
                    : Container(),
                formattedVinification.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Image.asset(
                                'assets/images/np_vinification.png',
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '${formattedVinification}',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                formattedVarietals.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 24,
                              child: Image.asset(
                                'assets/images/np_grapes_small.png',
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                '$formattedVarietals',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                SizedBox(height: 10),
                TextButton(
                  style: Theme.of(context).outlinedButtonTheme.style,
                  child: Text('Begin tasting'.toUpperCase()),
                  onPressed: () {
                    WineTasting initTasting = fromDocumentSnapshot(document);
                    Navigator.pushNamed(
                      context,
                      '/new-wine-tasting',
                      arguments: initTasting,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('naturalwinediscover').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Text('Loading...');

        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) => _buildListItem(context, snapshot.data.documents[index]),
        );
      },
    );
  }
}
