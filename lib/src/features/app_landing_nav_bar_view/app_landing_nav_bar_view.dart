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
  // Firebase.
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          child: Container(
            color: Colors.black38,
            height: 0.20,
          ),
          preferredSize: Size.fromHeight(0.5),
        ),
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Notes'.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                _auth.signOut();
              },
              child: Icon(CupertinoIcons.gear, color: Colors.black, size: 35),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Column(
                        children: <Widget>[
                          Text('What are we tasting?'.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                          const SizedBox(height: 40),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Coffee'.toUpperCase()),
                            onPressed: () {
                              // Dismiss the modal before navigating.
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-coffee-tasting');
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Wine'.toUpperCase()),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/new-wine-tasting');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 35),
            ),
          ),
        ],
      ),
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
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _selectedIndex = index);
          },
          children: _widgetOptions,
        ),
      ),
    );
  }
}
