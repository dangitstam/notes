import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/features/app_landing_nav_bar_view/app_landing_nav_bar_view.dart';
import 'package:notes/src/features/authenticate/authenticate.dart';
import 'package:notes/src/features/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/features/coffee_tasting_create_view/coffee_tasting_create_view.dart';
import 'package:notes/src/features/coffee_tasting_create_view/components/characteristics/characteristics_section.dart';
import 'package:notes/src/features/coffee_tasting_create_view/components/notes/notes_section.dart';
import 'package:notes/src/features/natural_wine_discovery_list_view/natural_wine_discovery_list_view.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/characteristics/wine_characteristics_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/info/wine_info_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/notes/wine_notes_section.dart';
import 'package:notes/src/features/wine_tasting_create_view/wine_tasting_create_view.dart';
import 'package:notes/src/services/auth_service.dart';
import 'package:notes/src/styles/light_theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Firebase app initialization.
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // TODO: Implement a loading screen.
      return Center(
        child: Text('loading', textDirection: TextDirection.ltr),
      );
    }

    return StreamProvider<User>.value(
      initialData: null,
      value: AuthService().user,
      child: HomeWrapper(),
    );
  }
}

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // Return either the app landing screen widget or authenticate widget.
    if (user == null) {
      return MaterialApp(
        title: 'Notes',
        theme: lightTheme,
        home: Authenticate(),
      );
    } else {
      final _router = AppRouter();
      return MaterialApp(
        title: 'Notes',
        theme: lightTheme,
        onGenerateRoute: _router.onGenerateRoute,
        home: AppLandingScreen(),
      );
    }
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
