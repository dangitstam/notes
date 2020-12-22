import 'package:flutter/material.dart';
import 'src/coffee_tasting_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Notes', initialRoute: '/', routes: {
      '/': (context) => CoffeeTastingListViewScreen(),
      '/second': (context) => CoffeeTastingCreateViewScreen(),
    });
  }
}

class CoffeeTastingListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: RaisedButton(
                color: Colors.lightBlue,
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/second');
                },
                child: Text('New', style: TextStyle(color: Colors.white)),
              ),
            ),
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
        body: Center(child: Text('Hello, Create View!')));
  }
}
