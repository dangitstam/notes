import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/characteristics_section.dart';
import 'package:notes/src/coffee_tasting_create_view/components/notes/notes_section.dart';
import 'package:notes/src/styles/light_theme.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/wine_characteristics_section.dart';
import 'package:notes/src/wine_tasting_create_view/wine_tasting_create_view.dart';

import 'src/coffee_tasting_create_view/coffee_tasting_create_view.dart';
import 'src/coffee_tasting_list_view/bloc/coffee_tasting_list_bloc.dart';
import 'src/coffee_tasting_list_view/coffee_tasting_list_view.dart';
import 'src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'src/wine_tasting_create_view/components/notes/wine_notes_section.dart';

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
  var _wineTastingCreateBloc = WineTastingCreateBloc();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) {
            // Subsequent nav to this screen necessitates a stream refresh.
            _coffeeTastingListBloc.refreshCoffeeTastingsStream();
            return BlocProvider.value(
              value: _coffeeTastingListBloc,
              child: CoffeeTastingListViewScreen(),
            );
          },
        );
      case '/create':
        return MaterialPageRoute(
          builder: (_) {
            // Reset the create tasting bloc on each navigate to '/create'.
            _coffeeTastingCreateBloc.close();
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

      // Wine
      case '/new-wine-tasting':
        return MaterialPageRoute(
          builder: (_) {
            // Reset the create tasting bloc on each navigate to '/create'.
            _wineTastingCreateBloc.close();
            _wineTastingCreateBloc = WineTastingCreateBloc();
            return BlocProvider.value(
              value: _wineTastingCreateBloc,
              child: WineTastingCreateViewScreen(),
            );
          },
        );
      case '/wine-notes':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _wineTastingCreateBloc,
            child: WineNotesScreen(),
          ),
        );
      case '/wine-characteristics':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _wineTastingCreateBloc,
            child: WineCharacteristicsScreen(),
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
