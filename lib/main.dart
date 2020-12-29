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
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                      Icon(CupertinoIcons.search,
                          color: Colors.black, size: 20),
                      SizedBox(width: 5),
                      Text('Search', style: caption())
                    ]))),
            Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: GestureDetector(
                    onTap: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pushNamed(context, '/create');
                    },
                    child: Icon(CupertinoIcons.plus_app,
                        color: Colors.black, size: 35))),
          ],
        ),
        body: CoffeeTastingListViewWidget());
  }
}

class CoffeeTastingCreateViewScreen extends StatelessWidget {
  final CoffeeTastingCreateViewWidget coffeeTastingCreateViewWidget =
      CoffeeTastingCreateViewWidget();

  @override
  Widget build(BuildContext context) {
    return coffeeTastingCreateViewWidget;
  }
}
