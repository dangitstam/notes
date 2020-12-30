import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'src/coffee_tasting_list_view/coffee_tasting_list_view.dart';
import 'src/coffee_tasting_create_view/coffee_tasting_create_view.dart';

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

class CoffeeTastingCreateViewScreen extends StatelessWidget {
  final CoffeeTastingCreateViewWidget coffeeTastingCreateViewWidget =
      CoffeeTastingCreateViewWidget();

  @override
  Widget build(BuildContext context) {
    return coffeeTastingCreateViewWidget; // TODO: Redundant wrapper.
  }
}
