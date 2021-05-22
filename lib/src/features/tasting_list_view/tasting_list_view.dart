import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/features/tasting_list_view/bloc/tasting_list_bloc.dart';
import 'package:notes/src/features/tasting_list_view/list_item_wine_tasting.dart';

class TastingListViewWidget extends StatefulWidget {
  TastingListViewWidget({Key key}) : super(key: key);

  @override
  _TastingListViewWidgetState createState() => _TastingListViewWidgetState();
}

class _TastingListViewWidgetState extends State<TastingListViewWidget> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin.

    BlocProvider.of<TastingListBloc>(context).add(InitTastings());

    // To access the tastings stored in Firebase:
    // final String uid = Provider.of<User>(context, listen: false).uid;
    // stream: FirebaseFirestore.instance.collection('user').doc(uid).collection('tastings').snapshots(),

    return StreamBuilder(
      stream: BlocProvider.of<TastingListBloc>(context).wineTastings,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasError || !snapshot.hasData) {
            // TODO: "Something went wrong" screen.
            return Container();
          }

          var tastings = snapshot.data;
          if (tastings.isEmpty) {
            return NoTastingsYetWidget();
          }

          return CustomScrollView(
            slivers: <Widget>[
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                automaticallyImplyLeading: false,
                centerTitle: false,
                elevation: 2,
                forceElevated: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                pinned: true,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Tastings'.toUpperCase(),
                        style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(CupertinoIcons.search, color: Colors.black, size: 30),
                    ),
                    const SizedBox(width: 17),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/new-wine-tasting');
                      },
                      child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 30),
                    ),
                  ],
                ),
              ),
              SliverAppBar(
                title: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: 'By Recent',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.caption,
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                CupertinoIcons.plus,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextSpan(
                            text: 'Add Filters',
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 17),
                    GestureDetector(
                      onTap: () {},
                      child: Icon(CupertinoIcons.square_grid_2x2, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                automaticallyImplyLeading: false,
                centerTitle: false,
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (BuildContext _context, int index) {
                    if (tastings != null && index < tastings.length) {
                      return Column(
                        children: [
                          Padding(
                            // Fencepost the padding to keep the first element close to the sorting/filtering buttons.
                            padding: index == 0 ? EdgeInsets.only(bottom: 17) : EdgeInsets.symmetric(vertical: 17),
                            child: WineTastingListItem(tasting: tastings[index]),
                          ),
                          // Only render a divider between elements.
                          index >= 0 && index < tastings.length - 1 ? Divider() : Container(),
                        ],
                      );
                    }
                    return Container();
                  },
                  // Builds 1000 ListTiles
                  childCount: tastings == null ? 0 : tastings.length,
                ),
              ),
            ],
          );
        } else {
          return Text('loading');
        }
      },
    );
  }
}

class NoTastingsYetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No tastings found.'.toUpperCase(),
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tap ',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.normal),
                ),
                WidgetSpan(
                  child: Icon(CupertinoIcons.plus_app, size: 16),
                ),
                TextSpan(
                  text: ' above to start your first tasting.',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Expanded(
//   child: TextFormField(
//     decoration: InputDecoration(
//       fillColor: Colors.grey.withAlpha(40),
//       filled: true,
//       isDense: true,
//       contentPadding: EdgeInsets.zero,
//       prefixIcon: Icon(
//         CupertinoIcons.search,
//         size: 20,
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.grey.withAlpha(40),
//         ),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.grey.withAlpha(40),
//         ),
//       ),
//       hintText: 'Search in past tastings',
//       counterText: '',
//     ),
//     onChanged: (value) {},
//     style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.w500),
//   ),
// ),
