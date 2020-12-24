import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'dart:convert' show json;

class _CoffeeTastingListItem extends StatelessWidget {
  _CoffeeTastingListItem(
      {Key key,
      this.title,
      this.origin,
      this.process,
      this.description,
      this.notes,
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

  Widget _buildCoffeeRatingLinearIndicator(String criteria, double value) {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Text('$criteria:',
              style: subtitle_1(), textAlign: TextAlign.right)),
      SizedBox(width: 5),
      Expanded(
          flex: 3,
          child: Stack(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xffd1d1d1),
                  value: (value - 6) / 4,
                  minHeight: 16,
                )),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                  padding: EdgeInsets.only(right: 7),
                  child: Text('$value',
                      style: caption(
                          color: Colors.white, fontStyle: FontStyle.italic))),
            )
          ]))
    ]);
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
                  const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(children: [
                          Icon(CupertinoIcons.location_solid,
                              size: 14, color: Colors.black),
                          Text(
                            '$origin',
                            style: caption(),
                          )
                        ]),
                        SizedBox(width: 5),
                        Row(children: [
                          Icon(
                            process == 'Natural'
                                ? CupertinoIcons.sun_max
                                : CupertinoIcons.drop,
                            size: 14,
                            color: Colors.black,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '$process',
                            style: caption(),
                          )
                        ])
                      ])
                ],
              ),
            ),
            SizedBox(height: 10),
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
            _buildCoffeeRatingLinearIndicator('Fragrance/Aroma', fragrance),
            SizedBox(height: 5),
            _buildCoffeeRatingLinearIndicator('Flavor', flavor),
            SizedBox(height: 5),
            _buildCoffeeRatingLinearIndicator('Aftertaste', aftertaste),
            SizedBox(height: 5),
            _buildCoffeeRatingLinearIndicator('Acidity', acidity),
            SizedBox(height: 5),
            _buildCoffeeRatingLinearIndicator('Body', body),
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
