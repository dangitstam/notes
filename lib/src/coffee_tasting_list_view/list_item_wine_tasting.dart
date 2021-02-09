import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/coffee_tasting_list_view/roast_level_linear_indicator.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/characteristics_chart.dart';

import 'coffee_tasting_hero_image_start.dart';

class WineTastingListItem extends StatelessWidget {
  WineTastingListItem({
    Key key,
    this.tasting,
  }) : super(key: key);

  final WineTasting tasting;

  Icon _buildRoastingProcessIcon(String process) {
    // TODO: Default to blank icon when process is neither 'Washed' or 'Natural'.
    return Icon(process == 'Natural' ? CupertinoIcons.sun_max : CupertinoIcons.drop, color: Colors.black, size: 14);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedId = tasting.wineTastingId.toString().padLeft(2, '0');
    return Container(
      padding: EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /**
           * Description and notes section.
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
                    /**
                     * Title section.
                     */
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
                        Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                Icon(CupertinoIcons.location_solid, size: 14, color: Colors.black),
                                Text(
                                  '${tasting.origin}',
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(width: 5),
                                _buildRoastingProcessIcon(tasting.process),
                                SizedBox(width: 2),
                                Text(
                                  '${tasting.process}',
                                  style: Theme.of(context).textTheme.caption,
                                )
                              ],
                            ),
                          ),
                          Expanded(flex: 1, child: RoastLevelLinearIndicator(tasting.roastLevel / 10)),
                        ])
                      ],
                    ),
                    const SizedBox(height: 10),
                    /**
                     *  Optional image of tasting.
                     */
                    tasting.imagePath != null
                        ? CoffeeTastingHeroImageStart(
                            tag: 'list view hero image for tasting ${tasting.wineTastingId}',
                            imagePath: tasting.imagePath,
                          )
                        : Container(),
                    tasting.imagePath != null ? const SizedBox(height: 10) : Container(),
                    Text(
                      '${tasting.description}',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 5),
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
