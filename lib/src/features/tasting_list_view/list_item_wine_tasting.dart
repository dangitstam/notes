import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/common/wine_utils.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/characteristics/characteristics_chart.dart';
import 'package:readmore/readmore.dart';

import 'tasting_hero_image_start.dart';

class WineTastingListItem extends StatelessWidget {
  WineTastingListItem({
    Key key,
    this.tasting,
  }) : super(key: key);

  final WineTasting tasting;

  @override
  Widget build(BuildContext context) {
    final String formattedId = tasting.wineTastingId.toString().padLeft(1, '0');
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

    Icon wineTypeIcon;
    switch (tasting.wineType) {
      case 'Red':
        wineTypeIcon = Icon(
          CupertinoIcons.circle_filled,
          color: Color(0xff850024),
          size: 20,
        );
        break;
      case 'White':
        wineTypeIcon = Icon(
          CupertinoIcons.circle,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        );
        break;
      case 'Skin Contact':
        wineTypeIcon = Icon(
          CupertinoIcons.circle_lefthalf_fill,
          color: Color(0xffffa500),
          size: 20,
        );
        break;
      case 'Rosé':
        wineTypeIcon = Icon(
          CupertinoIcons.circle_lefthalf_fill,
          color: Color(0xff850024),
          size: 20,
        );
        break;
      default:
        wineTypeIcon = Icon(
          CupertinoIcons.circle,
          color: Theme.of(context).colorScheme.primary,
          size: 20,
        );
    }

    String formattedVinification = '';
    List<String> vinificationFacts = formatVinification(tasting);
    if (vinificationFacts.isNotEmpty) {
      formattedVinification = vinificationFacts.join(' · ');
    }

    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      /**
                       * Title section.
                       */
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${tasting.name}'.toUpperCase(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0),
                            child: Text(
                              '${tasting.winemaker} · ${wineFactsText}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // TODO: Edit button here.
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     // Text('  Wine', style: Theme.of(context).textTheme.subtitle2),
                    //     // const SizedBox(height: 5),
                    //     Text(
                    //       '#${formattedId}',
                    //       style: Theme.of(context).textTheme.headline6,
                    //       textAlign: TextAlign.end,
                    //     ),
                    //   ],
                    // ),
                  ],
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
                              aspectRatio: 1,
                              child: Icon(CupertinoIcons.location_solid, size: 20, color: Colors.black),
                            ),
                          ),
                          Text(
                            '${tasting.origin}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /**
                 *  Description.
                 */
                ReadMoreText(
                  '${tasting.description}',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  colorClickableText: Theme.of(context).colorScheme.primary,
                  trimCollapsedText: 'more',
                  trimExpandedText: 'less',
                  delimiter: ' ... ',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                tasting.imagePath != null ? const SizedBox(height: 10) : Container(),
                /**
                 *  Optional image of tasting.
                 */
                tasting.imagePath != null
                    ? TastingHeroImageStart(
                        tag: 'list view hero image for tasting ${tasting.wineTastingId}',
                        imagePath: tasting.imagePath,
                      )
                    : Container(),
                /**
                 * Characteristics.
                 */
                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.zero,
                    title: Text(
                      'Show Characteristics',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CharacteristicsChart(tasting: tasting),
                        ],
                      ),
                      const SizedBox(height: 17),
                    ],
                  ),
                ),
                /**
                 * Tasting Notes.
                 */
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 5,
                  runSpacing: 5,
                  children: tasting.notes.map((e) => TastingNote(e)).toList(),
                ),
                /**
                 * Vinification.
                 */
                formattedVinification.isNotEmpty ? const SizedBox(height: 17) : Container(),
                formattedVinification.isNotEmpty
                    ? Row(
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
                      )
                    : Container(),
                /**
                 * Varietals.
                 */
                formattedVarietals.isNotEmpty ? const SizedBox(height: 10) : Container(),
                formattedVarietals.isNotEmpty
                    ? Row(
                        children: [
                          Container(
                            height: 24,
                            child: Image.asset(
                              'assets/images/np_grapes_small.png',
                              color: Theme.of(context).colorScheme.onSurface,
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
                tasting.story.isNotEmpty ? const SizedBox(height: 10) : Container(),
                tasting.story.isNotEmpty
                    ? Row(
                        children: [
                          Container(
                            height: 24,
                            child: Image.asset(
                              'assets/images/np_book.png',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: GestureDetector(
                              child: Text(
                                'Read more about this wine',
                                style: Theme.of(context).textTheme.caption.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                              onTap: () {
                                wineStoryModal(context, tasting);
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(height: 17),
                /**
                 * Date & time that this tasting took place.
                 */
                Text(
                  '10:35 AM · Dec 23 2020',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 17),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> wineStoryModal(
  BuildContext context,
  WineTasting tasting,
) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${tasting.name}'.toUpperCase(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2.0),
              child: Text(
                '${tasting.winemaker}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            const SizedBox(height: 17),
            Text(
              '${tasting.story}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      );
    },
  );
}
