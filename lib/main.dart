import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/characteristics_section.dart';
import 'package:notes/src/coffee_tasting_create_view/components/notes/notes_section.dart';
import 'package:notes/src/styles/light_theme.dart';

import 'src/coffee_tasting_create_view/coffee_tasting_create_view.dart';
import 'src/coffee_tasting_list_view/bloc/coffee_tasting_list_bloc.dart';
import 'src/coffee_tasting_list_view/coffee_tasting_list_view.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final _router = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: lightTheme,
      onGenerateRoute: _router.onGenerateRoute,
    );
  }
}

class AppRouter {
  var _coffeeTastingListBloc = CoffeeTastingListBloc();
  var _coffeeTastingCreateBloc = CoffeeTastingCreateBloc();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _coffeeTastingListBloc,
            child: CoffeeTastingListViewScreen(),
          ),
        );
      case '/create':
        return MaterialPageRoute(
          builder: (_) {
            // Reset the create tasting bloc on each navigate to '/create'.
            dispose();
            _coffeeTastingCreateBloc = CoffeeTastingCreateBloc();
            return BlocProvider.value(
              value: _coffeeTastingCreateBloc,
              child: CoffeeTastingCreateViewScreen(),
            );
          },
        );
      case '/notes':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _coffeeTastingCreateBloc,
            child: NotesScreen(),
          ),
        );
      case '/characteristics':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _coffeeTastingCreateBloc,
            child: CharacteristicsScreen(),
          ),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _coffeeTastingListBloc.close();
    _coffeeTastingCreateBloc.close();
  }
}
