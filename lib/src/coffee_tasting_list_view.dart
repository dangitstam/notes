import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'dart:convert' show json;
import 'dart:math' show max;

class _CoffeeTastingListItem extends StatelessWidget {
  _CoffeeTastingListItem(
      {Key key,
      this.title,
      this.origin,
      this.process,
      this.description,
      this.notes,
      this.roastLevel,
      this.thumbnail,
      this.acidity,
      this.aftertaste,
      this.body,
      this.flavor,
      this.fragrance})
      : super(key: key);

  final String title;
  final String origin;
  final String process;
  final String description;
  final List<String> notes;
  final double roastLevel;
  final Widget thumbnail;

  // SCA criteria.
  final double acidity;
  final double aftertaste;
  final double body;
  final double flavor;
  final double fragrance;

  static Widget fromTastingJson(tasting) {
    return _CoffeeTastingListItem(
      thumbnail: Container(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  Image.asset('assets/images/coffee.jpg', fit: BoxFit.cover))),
      title: "${tasting['roaster']}, ${tasting['coffee_name']}",
      origin: tasting['origin'],
      process: tasting['process'],
      description: '${tasting['description']}',
      notes: tasting['notes'].cast<String>(),
      roastLevel: tasting['roast_level'],
      acidity: tasting['sca']['acidity'],
      aftertaste: tasting['sca']['aftertaste'],
      body: tasting['sca']['body'],
      flavor: tasting['sca']['flavor'],
      fragrance: tasting['sca']['fragrance/aroma'],
    );
  }

  List<Widget> displayNotes(List<String> notes) {
    var noteColors = {
      'Chocolate': Color(0xff4B240A),
      'Sugarcane': Color(0xffB48B53),
      'Black Cherry': Color(0xff4A1229),
      'Plum': Color(0xff25344E),
      'Raisin': Color(0xff4A1229),
      'Oatmeal': Color(0xff90715C),
      'Spice': Color(0xffd3574b),
      'Blueberry': Color(0xff123456),
      'Orange': Color(0xffFFB52C),
      'Cherry': Color(0xffA51515),
    };

    return notes.map((e) {
      return Container(
        child: Text('$e', style: caption(color: Colors.white)),
        margin: const EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
            color:
                noteColors.containsKey(e) ? noteColors[e] : Colors.blueAccent),
        padding: EdgeInsets.all(7.0),
      );
    }).toList();
  }

  Widget _buildCoffeeRoastLevelLinearIndicator(double value) {
    return Row(children: [
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
            )),
      )
    ]);
  }

  Icon _buildRoastingProcessIcon(String process) {
    // TODO: Default to blank icon when process is neither 'Washed' or 'Natural'.
    return Icon(
        process == 'Natural' ? CupertinoIcons.sun_max : CupertinoIcons.drop,
        color: Colors.black,
        size: 14);
  }

  Widget _buildScaCriteriaCaption(String criteria) {
    return Container(
        height: 20,
        child: Align(
            alignment: Alignment.center,
            child: Text('$criteria',
                textAlign: TextAlign.right, style: caption())));
  }

  Widget _buildScaCriteriaRatingLinearIndicator(double value) {
    // SCA ratings begin at a minimum of 6.
    // `value` is scaled so that a value of 6.0 appears as an empty bar.
    var scaledValue = (value - 6) / 4;
    return Padding(
        padding: EdgeInsets.only(top: 2, bottom: 2),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(2.3),
              child: LinearProgressIndicator(
                backgroundColor: Color(0xffd1d1d1),
                value: scaledValue,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                minHeight: 16,
              )),
          LayoutBuilder(builder: (context, constrains) {
            // Subtracting a fixed amount ensures the value appears in the
            // colored part of the linear indicator and not outside of
            // the entire bar at any point.
            var leftPadding = max(constrains.maxWidth * scaledValue - 20, 0.0);
            return Padding(
                padding: EdgeInsets.only(left: leftPadding),
                child: Text('$value',
                    style: caption(
                        color: Colors.white, fontStyle: FontStyle.italic)));
          }),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /**
             * Title section.
            */
            Expanded(
              flex: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '$title',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: heading_6(),
                  ),
                  const SizedBox(height: 5),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Row(children: [
                              Icon(CupertinoIcons.location_solid,
                                  size: 14, color: Colors.black),
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
                            ])),
                        Expanded(
                            flex: 1,
                            child: _buildCoffeeRoastLevelLinearIndicator(
                                roastLevel)),
                      ])
                ],
              ),
            ),
            const SizedBox(height: 10),
            /**
             * Description and notes section.
            */
            Expanded(
              flex: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: thumbnail,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(children: <Widget>[
                      Text(
                        '$description',
                        style: body_1(),
                      ),
                      SizedBox(height: 5),
                      Row(children: displayNotes(notes))
                    ]),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            /**
             * SCA criteria.
            */
            Row(children: [
              Expanded(
                  flex: 0,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildScaCriteriaCaption('Acidity'),
                        _buildScaCriteriaCaption('Aftertaste'),
                        _buildScaCriteriaCaption('Body'),
                        _buildScaCriteriaCaption('Flavor'),
                        _buildScaCriteriaCaption('Fragrance/Aroma'),
                      ])),
              SizedBox(
                width: 5,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildScaCriteriaRatingLinearIndicator(acidity),
                  _buildScaCriteriaRatingLinearIndicator(body),
                  _buildScaCriteriaRatingLinearIndicator(aftertaste),
                  _buildScaCriteriaRatingLinearIndicator(flavor),
                  _buildScaCriteriaRatingLinearIndicator(fragrance),
                ],
              ))
            ]),
          ],
        ));
  }
}

class CoffeeTastingListViewWidget extends StatelessWidget {
  CoffeeTastingListViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/coffee_tastings.json'),
        builder: (context, snapshot) {
          // Decode the JSON
          var coffeeTastings = json.decode(snapshot.data.toString());
          return ListView.separated(
              itemCount: coffeeTastings == null ? 0 : coffeeTastings.length,
              itemBuilder: (BuildContext _context, int index) {
                if (coffeeTastings != null && index < coffeeTastings.length) {
                  return _CoffeeTastingListItem.fromTastingJson(
                      coffeeTastings[index]);
                } else {
                  return null;
                }
              },
              padding: const EdgeInsets.all(0.0),
              separatorBuilder: (context, index) => Divider());
        });
  }
}
