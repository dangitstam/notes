import 'package:flutter/material.dart';
import 'src/coffee_tasting_list_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Notes',
        home: Scaffold(
            appBar: AppBar(title: const Text('Notes')),
            body: CoffeeTastingListViewWidget()));
  }
}
