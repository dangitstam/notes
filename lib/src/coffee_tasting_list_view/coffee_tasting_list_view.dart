import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/characteristics_chart.dart';
import 'package:notes/src/coffee_tasting_list_view/bloc/coffee_tasting_list_bloc.dart';
import 'package:notes/src/coffee_tasting_list_view/coffee_tasting_hero_image_start.dart';
import 'package:notes/src/coffee_tasting_list_view/roast_level_linear_indicator.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

// TODO: Abstract into its own file.
class CoffeeTastingListViewScreen extends StatelessWidget {
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
                    Navigator.pushNamed(context, '/create');
                  },
                  child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 35))),
        ],
      ),
      body: CoffeeTastingListViewWidget(),
    );
  }
}

class CoffeeTastingListViewWidget extends StatelessWidget {
  CoffeeTastingListViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CoffeeTastingListBloc>(context).add(InitCoffeeTastingList());
    return StreamBuilder(
      stream: BlocProvider.of<CoffeeTastingListBloc>(context).coffeeTastings,
      builder: (context, AsyncSnapshot<List<CoffeeTasting>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var coffeeTastings = snapshot.data;
          return ListView.separated(
              itemCount: coffeeTastings == null ? 0 : coffeeTastings.length,
              itemBuilder: (BuildContext _context, int index) {
                if (coffeeTastings != null && index < coffeeTastings.length) {
                  return _CoffeeTastingListItem(tasting: coffeeTastings[index]);
                } else {
                  return Text('loading');
                }
              },
              padding: const EdgeInsets.all(0.0),
              separatorBuilder: (context, index) => Divider());
        } else {
          return Text('loading');
        }
      },
    );
  }
}

class _CoffeeTastingListItem extends StatelessWidget {
  _CoffeeTastingListItem({
    Key key,
    this.tasting,
  }) : super(key: key);

  final CoffeeTasting tasting;

  Icon _buildRoastingProcessIcon(String process) {
    // TODO: Default to blank icon when process is neither 'Washed' or 'Natural'.
    return Icon(process == 'Natural' ? CupertinoIcons.sun_max : CupertinoIcons.drop, color: Colors.black, size: 14);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedId = tasting.coffeeTastingId.toString().padLeft(3, '0');
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
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${formattedId}.',
                  style: Theme.of(context).textTheme.subtitle2.copyWith(fontSize: 16),
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
                          '${tasting.coffeeName}'.toUpperCase(),
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
                            tag: 'list view hero image for tasting ${tasting.coffeeTastingId}',
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
