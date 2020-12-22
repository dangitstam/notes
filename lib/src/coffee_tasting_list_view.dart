import 'package:flutter/material.dart';
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
        decoration: const BoxDecoration(color: Colors.brown),
      ),
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 300,
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
                  Text('$title', maxLines: 2, overflow: TextOverflow.ellipsis),
                  const Padding(padding: EdgeInsets.only(bottom: 2.0)),
                  Text(
                    '$origin',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
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
                  Expanded(
                    flex: 2,
                    child: Column(children: <Widget>[
                      Text('$description'),
                      Text(notes.join(' '))
                    ]),
                  )
                ],
              ),
            ),
            /**
             * SCA criteria.
            */
            Text('Acidity: $acidity'),
            Text('Aftertaste: $aftertaste'),
            Text('Body: $body'),
            Text('Flavor: $flavor'),
            Text('Fragrance: $fragrance'),
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
              separatorBuilder: (context, index) => Divider(),
              padding: const EdgeInsets.all(0.0),
              itemCount: coffeeTastings == null ? 0 : coffeeTastings.length,
              itemBuilder: (BuildContext _context, int index) {
                if (coffeeTastings != null && index < coffeeTastings.length) {
                  return _CoffeeTastingListItem.fromTastingJson(
                      coffeeTastings[index]);
                } else {
                  return null;
                }
              });
        });
  }
}
