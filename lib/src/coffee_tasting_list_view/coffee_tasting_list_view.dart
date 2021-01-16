import 'dart:math' show max;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_list_view/bloc/coffee_tasting_list_bloc.dart';
import 'package:notes/src/coffee_tasting_list_view/coffee_tasting_hero_image_start.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/styles/typography.dart';
import 'package:notes/src/util.dart';

// TODO: Abstract into its own file.
class CoffeeTastingListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
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
            'Notes',
            style: heading_5(),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                    onTap: () {
                      // TODO: Filter implementation.
                    },
                    child: Row(children: [Text('Filter', style: caption())]))),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                    onTap: () {
                      // TODO: Filter implementation.
                    },
                    child: Row(children: [Text('Sort', style: caption())]))),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                    onTap: () {
                      // TODO: Filter implementation.
                    },
                    child: Row(children: [
                      Icon(CupertinoIcons.search, color: Colors.black, size: 20),
                      SizedBox(width: 5),
                      Text('Search', style: caption())
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
        body: BlocProvider<CoffeeTastingListBloc>(
          create: (context) => CoffeeTastingListBloc(),
          child: CoffeeTastingListViewWidget(),
        ));
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
                  return _CoffeeTastingListItem.fromCoffeeTasting(coffeeTastings[index]);
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
    this.id,
    this.title,
    this.origin,
    this.process,
    this.description,
    this.notes,
    this.roastLevel,
    this.acidity,
    this.aftertaste,
    this.body,
    this.flavor,
    this.fragrance,
    this.imagePath,
  }) : super(key: key);

  // TODO: Would it be easier to just store the coffee tasting?
  final int id;
  final String title;
  final String origin;
  final String process;
  final String description;
  final List<Note> notes;
  final double roastLevel;
  final String imagePath;

  // SCA criteria.
  final double acidity;
  final double aftertaste;
  final double body;
  final double flavor;
  final double fragrance;

  static Widget fromCoffeeTasting(CoffeeTasting tasting) {
    return _CoffeeTastingListItem(
      id: tasting.coffeeTastingId,
      title: '${tasting.roaster}, ${tasting.coffeeName}',
      origin: tasting.origin,
      process: tasting.process,
      description: tasting.description,
      notes: tasting.notes,
      roastLevel: tasting.roastLevel,
      acidity: tasting.acidity,
      aftertaste: tasting.aftertaste,
      body: tasting.body,
      flavor: tasting.flavor,
      fragrance: tasting.fragrance,
      imagePath: tasting.imagePath,
    );
  }

  Widget _buildCoffeeRoastLevelLinearIndicator(double value) {
    return Row(
      children: [
        Text('Roast Level', style: caption(), textAlign: TextAlign.left),
        SizedBox(width: 5),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2.0),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xffd1d1d1),
              value: value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
              minHeight: 14,
            ),
          ),
        )
      ],
    );
  }

  Icon _buildRoastingProcessIcon(String process) {
    // TODO: Default to blank icon when process is neither 'Washed' or 'Natural'.
    return Icon(process == 'Natural' ? CupertinoIcons.sun_max : CupertinoIcons.drop, color: Colors.black, size: 14);
  }

  Widget _buildScaCriteriaCaption(String criteria) {
    return Container(
      height: 45,
      child: Center(
        child: Text(
          '$criteria',
          textAlign: TextAlign.right,
          style: caption(),
        ),
      ),
    );
  }

  Widget _buildScaCriteriaRatingLinearIndicator(double value) {
    // SCA ratings begin at a minimum of 6.
    // `value` is scaled so that a value of 6.0 appears as an empty bar.
    var scaledValue = (value - 6) / 4;
    var formattedValue = value == 10.0 ? 'Score: 10' : 'Score: $value';
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.3),
            child: Container(
              height: 16,
              child: LinearProgressIndicator(
                backgroundColor: Color(0xffd1d1d1),
                value: scaledValue,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff1b1b1b)),
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constrains) {
              // Subtracting a fixed amount ensures the value appears in the
              // colored part of the linear indicator and not outside of
              // the entire bar at any point.
              var leftPadding = max(constrains.maxWidth * scaledValue - 60, 0.0);
              return Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Text('$formattedValue', style: caption(color: Colors.white, fontStyle: FontStyle.italic)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScaCriteriaIntensityLinearIndicator(double value) {
    // SCA ratings begin at a minimum of 6.
    // `value` is scaled so that a value of 6.0 appears as an empty bar.
    var scaledValue = (value - 6) / 4;
    var formattedValue = value == 10.0 ? 'Intensity: 10' : 'Intensity: $value';
    return Padding(
      padding: EdgeInsets.only(top: 2, bottom: 7),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(2.3),
            child: LinearProgressIndicator(
              backgroundColor: Color(0xffd1d1d1),
              value: scaledValue,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffa6a397)),
              minHeight: 16,
            ),
          ),
          LayoutBuilder(
            builder: (context, constrains) {
              // Subtracting a fixed amount ensures the value appears in the
              // colored part of the linear indicator and not outside of
              // the entire bar at any point.
              var leftPadding = max(constrains.maxWidth * scaledValue - 75, 0.0);
              return Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Text('$formattedValue', style: caption(color: Colors.white, fontStyle: FontStyle.italic)),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /**
             * Title section.
            */
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: heading_6(),
              ),
              const SizedBox(height: 5),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.location_solid, size: 14, color: Colors.black),
                      Text(
                        '$origin',
                        style: caption(),
                      ),
                      SizedBox(width: 5),
                      _buildRoastingProcessIcon(process),
                      SizedBox(width: 2),
                      Text(
                        '$process',
                        style: caption(),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 1, child: _buildCoffeeRoastLevelLinearIndicator(roastLevel)),
              ])
            ],
          ),
          const SizedBox(height: 10),
          /**
           *  Optional image of tasting.
           */
          imagePath != null
              ? CoffeeTastingHeroImageStart(tag: 'list view hero image for tasting $id', imagePath: imagePath)
              : Container(),
          imagePath != null ? const SizedBox(height: 10) : Container(),
          /**
             * Description and notes section.
            */
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Text(
                      '$description',
                      style: body_1(),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      spacing: 5,
                      children: notes.map((e) => TastingNote(e)).toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 10),
          /**
             * SCA criteria.
            */
          Row(
            children: [
              Expanded(
                flex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildScaCriteriaCaption('Aroma'),
                    _buildScaCriteriaCaption('Acidity'),
                    _buildScaCriteriaCaption('Body'),
                    _buildScaCriteriaCaption('Aftertaste'),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildScaCriteriaRatingLinearIndicator(fragrance),
                    _buildScaCriteriaIntensityLinearIndicator(fragrance),
                    _buildScaCriteriaRatingLinearIndicator(acidity),
                    _buildScaCriteriaIntensityLinearIndicator(acidity),
                    _buildScaCriteriaRatingLinearIndicator(body),
                    _buildScaCriteriaIntensityLinearIndicator(body),
                    _buildScaCriteriaRatingLinearIndicator(aftertaste),
                    _buildScaCriteriaIntensityLinearIndicator(aftertaste),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          /**
             * Date & time that this tasting took place.
             */
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              '10:35 AM · Dec 23 2020',
              style: caption(),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}
