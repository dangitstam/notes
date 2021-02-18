import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/common/wine_utils.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/characteristics_chart.dart';

import 'tasting_hero_image_start.dart';

class WineTastingListItem extends StatelessWidget {
  WineTastingListItem({
    Key key,
    this.tasting,
  }) : super(key: key);

  final WineTasting tasting;

  @override
  Widget build(BuildContext context) {
    final String formattedId = tasting.wineTastingId.toString().padLeft(2, '0');
    final String formattedVarietals = formatVarietals(tasting);

    /**
     * Type (color, bubbles), vintage, alcohol by volume.
     */
    List<String> wineFacts = [];
    String formattedType = '${tasting.wineType} ${tasting.bubbles}'.trim();
    if (formattedType.isNotEmpty) {
      wineFacts.add(formattedType);
    }

    // TODO: Migrate to null safety.
    if (tasting.vintage != null && tasting.vintage > 0) {
      wineFacts.add('${tasting.vintage}');
    }
    if (tasting.alcoholByVolume != null && tasting.alcoholByVolume >= 0.0) {
      wineFacts.add('Alc. ${tasting.alcoholByVolume}% by vol.');
    }

    String wineFactsText = wineFacts.join(' · ');

    return Container(
      padding: EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /**
           * Title section.
           */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 17, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('  Wine', style: Theme.of(context).textTheme.subtitle2),
                    const SizedBox(height: 5),
                    Text(
                      '${formattedId}.',
                      style: Theme.of(context).textTheme.subtitle2,
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${tasting.roaster}'.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '${tasting.name}'.toUpperCase(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Row(
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
                                    '${tasting.origin}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    /**
                     *  Optional image of tasting.
                     */
                    tasting.imagePath != null
                        ? TastingHeroImageStart(
                            tag: 'list view hero image for tasting ${tasting.wineTastingId}',
                            imagePath: tasting.imagePath,
                          )
                        : Container(),
                    tasting.imagePath != null ? const SizedBox(height: 10) : Container(),
                    /**
                     *  Description.
                     */
                    Text(
                      '${tasting.description}',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.start,
                    ),
                    /**
                     * Type, Vintage, Alcohol by volume.
                     */
                    wineFactsText.isNotEmpty ? const SizedBox(height: 10) : Container(),
                    wineFactsText.isNotEmpty
                        ? Text(
                            '$wineFactsText',
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.end,
                          )
                        : Container(),
                    /**
                     * Vinification.
                     */
                    tasting.vinification.isNotEmpty ? const SizedBox(height: 10) : Container(),
                    tasting.vinification.isNotEmpty
                        ? Row(
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
                                  '${tasting.vinification}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    /**
                     * Varietals.
                     */
                    formattedVarietals.isNotEmpty ? const SizedBox(height: 10) : Container(),
                    formattedVarietals.isNotEmpty
                        ? Row(
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
                          )
                        : Container(),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      children: tasting.notes.map((e) => TastingNote(e)).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          /**
           * Criteria
           */
          CharacteristicsChart(tasting: tasting),
          const SizedBox(height: 20),
          /**
            * Date & time that this tasting took place.
            */
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '10:35 AM · Dec 23 2020',
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
