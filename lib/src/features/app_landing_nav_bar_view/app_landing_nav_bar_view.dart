import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/features/natural_wine_discovery_list_view/natural_wine_discovery_list_view.dart';
import 'package:notes/src/features/tasting_list_view/bloc/tasting_list_bloc.dart';
import 'package:notes/src/features/tasting_list_view/tasting_list_view.dart';
import 'package:notes/src/services/auth_service.dart';

class AppLandingScreen extends StatefulWidget {
  @override
  _AppLandingScreenState createState() => _AppLandingScreenState();
}

class _AppLandingScreenState extends State<AppLandingScreen> {
  // Authentication.
  final AuthService _auth = AuthService();

  // Navigation bar.
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    NaturalWineDiscoveryListViewWidget(),
    BlocProvider.value(
      value: TastingListBloc(),
      child: TastingListViewWidget(),
    ),
  ];

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Theme.of(context).textTheme.bodyText2 causes the following error:
    // Another exception was thrown: 'package:flutter/src/painting/text_style.dart':
    // Failed assertion: line 937 pos 12: 'a == null || b == null || a.inherit == b.inherit': is not true.
    // Explicitly set with a `TextStyle` object as a workaround.
    var navBarTextStyle = TextStyle(
      fontFamily: 'Jost',
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Theme.of(context).colorScheme.background,
        unselectedLabelStyle: navBarTextStyle,
        selectedLabelStyle: navBarTextStyle,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/np_library.png'),
            ),
            label: 'My Tastings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(150),
        onTap: _onItemTapped,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _selectedIndex = index);
            },
            children: _widgetOptions,
          ),
        ),
      ),
    );
  }
}
