import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/coffee_tasting_create_view.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/characteristics_section.dart';
import 'package:notes/src/coffee_tasting_create_view/components/notes/notes_section.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/features/app_landing_nav_bar_view/app_landing_nav_bar_view.dart';
import 'package:notes/src/features/natural_wine_discovery_list_view/natural_wine_discovery_list_view.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/characteristics/wine_characteristics_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/info/wine_info_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/notes/wine_notes_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/wine_tasting_create_view.dart';
import 'package:notes/src/styles/light_theme.dart';

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
  var _coffeeTastingCreateBloc = CoffeeTastingCreateBloc();
  var _wineTastingCreateBloc = WineTastingCreateBloc();

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) {
            return AppLandingScreen();
          },
        );
      case '/new-coffee-tasting':
        return MaterialPageRoute(
          builder: (_) {
            // Reset the create tasting bloc on each navigate to '/new-coffee-tasting'.
            _coffeeTastingCreateBloc.close();
            _coffeeTastingCreateBloc = CoffeeTastingCreateBloc();
            return BlocProvider.value(
              value: _coffeeTastingCreateBloc,
              child: CoffeeTastingCreateViewScreen(),
            );
          },
        );
      case '/coffee-notes':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _coffeeTastingCreateBloc,
            child: NotesScreen(),
          ),
        );
      case '/coffee-characteristics':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _coffeeTastingCreateBloc,
            child: CharacteristicsScreen(),
          ),
        );

      // Wine
      case '/natural-wine-discover':
        return MaterialPageRoute(
          builder: (_) {
            return NaturalWineDiscoveryListViewScreen();
          },
        );
      case '/new-wine-tasting':
        return MaterialPageRoute(
          builder: (_) {
            // Reset the create tasting bloc on each navigate to '/new-wine-tasting'.
            _wineTastingCreateBloc.close();

            // Optionally pre-populate fields in the tasting.
            var initTastingFromWineDoc = settings.arguments;
            _wineTastingCreateBloc = initTastingFromWineDoc != null && initTastingFromWineDoc is WineTasting
                ? WineTastingCreateBloc(initTasting: initTastingFromWineDoc)
                : WineTastingCreateBloc();

            return BlocProvider.value(
              value: _wineTastingCreateBloc,
              child: WineTastingCreateViewScreen(),
            );
          },
        );
      case '/wine-info':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _wineTastingCreateBloc,
            child: WineInfoScreen(),
          ),
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
    _coffeeTastingCreateBloc.close();
    _wineTastingCreateBloc.close();
  }
}
