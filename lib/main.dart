import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/styles/typography.dart';
import 'src/coffee_tasting_list_view.dart';
import 'src/coffee_tasting_create_view.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Notes', initialRoute: '/', routes: {
      '/': (context) => CoffeeTastingListViewScreen(),
      '/create': (context) => CoffeeTastingCreateViewScreen(),
    });
  }
}

class CoffeeTastingListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            'Notes',
            style: heading_5(),
          ),
          backgroundColor: Colors.white,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FlatButton(
                    color: Colors.black,
                    child: Text('New', style: body_1(color: Colors.white)),
                    onPressed: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pushNamed(context, '/create');
                    },
                  ),
                )),
          ],
        ),
        body: CoffeeTastingListViewWidget());
  }
}

class CoffeeTastingCreateViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          leading: GestureDetector(
            onTap: () {
              // Navigate to the second screen using a named route.
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back, // add custom icons also
            ),
          ),
        ),
        body: CoffeeTastingCreateViewWidget());
  }
}
