import 'dart:convert' show json;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final TextStyle _fontFamily = const TextStyle(fontFamily: 'Baskerville');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notes',
        home: Scaffold(
            appBar: AppBar(title: const Text('Notes')),
            body: _buildTastings(context)));
  }

  Widget _buildRow(Map tasting) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text("${tasting['roaster']}, ${tasting['coffee_name']}",
          style: _fontFamily),
    );
  }

  Widget _buildTastings(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/coffee_tastings.json'),
        builder: (context, snapshot) {
          // Decode the JSON
          var coffee_tastings = json.decode(snapshot.data.toString());

          return ListView.builder(
              padding: const EdgeInsets.only(left: 0, top: 5),
              // The itemBuilder callback is called once per suggested
              // word pairing, and places each suggestion into a ListTile
              // row. For even rows, the function adds a ListTile row for
              // the word pairing. For odd rows, the function adds a
              // Divider widget to visually separate the entries. Note that
              // the divider may be difficult to see on smaller devices.
              itemBuilder: (BuildContext _context, int i) {
                // Add a one-pixel-high divider widget before each row
                // in the ListView.
                if (i.isOdd) {
                  return Divider();
                }

                // The syntax "i ~/ 2" divides i by 2 and returns an
                // integer result.
                // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
                // This calculates the actual number of word pairings
                // in the ListView,minus the divider widgets.
                final int index = i ~/ 2;
                // If you've reached the end of the available word
                // pairings...
                if (index < coffee_tastings.length) {
                  return _buildRow(coffee_tastings[index]);
                }
                return null;
              });
        });
  }
}
