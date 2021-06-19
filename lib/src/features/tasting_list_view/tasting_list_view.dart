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
            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: CustomScrollView(
                slivers: <Widget>[
                  // Add the app bar to the CustomScrollView.
                  SliverPadding(
                    padding: EdgeInsets.only(top: 10.0),
                    sliver: TastingListViewAppBar(),
                  ),
                  SliverFillRemaining(
                    child: NoTastingsYetWidget(),
                  )
                ],
              ),
            );
          }

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: CustomScrollView(
              slivers: <Widget>[
                // Add the app bar to the CustomScrollView.
                SliverPadding(
                  padding: EdgeInsets.only(top: 10.0),
                  sliver: TastingListViewAppBar(),
                ),
                TastingListFilterSortViewBar(),
                // Next, create a SliverList
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
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
                    childCount: tastings == null ? 0 : tastings.length,
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text('loading');
        }
      },
    );
  }
}

/// The main app bar that displays the current page title, while enabling free text search and starting new tastings.
class TastingListViewAppBar extends StatefulWidget {
  @override
  _TastingListViewAppBarState createState() => _TastingListViewAppBarState();
}

class _TastingListViewAppBarState extends State<TastingListViewAppBar> with TickerProviderStateMixin {
  bool _searching = false;

  // Define the focus node for the search text field, enabling the app bar to focus and unfocus the field.
  // To manage the lifecycle, create the FocusNode in the initState method, and clean it up in the dispose method.
  FocusNode searchTextFieldFocusNode;

  final TextEditingController _searchTermController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextFieldFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    double searchTextFieldOpacity = _searching ? 1.0 : 0;

    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      pinned: true,
      title: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Row(
            children: [
              Text(
                'Tastings'.toUpperCase(),
                style: _searching
                    ? Theme.of(context).textTheme.overline.copyWith(
                          color: Colors.transparent,
                          fontSize: 24,
                        )
                    : Theme.of(context).textTheme.overline.copyWith(
                          fontSize: 24,
                        ),
                textAlign: TextAlign.start,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: searchTextFieldOpacity,
                  duration: Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: TextFormField(
                    controller: _searchTermController,
                    focusNode: searchTextFieldFocusNode,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        CupertinoIcons.search,
                        size: 20,
                      ),
                      isDense: true,
                      hintText: 'Search past tastings...',
                      counterText: '',
                    ),
                    onChanged: (value) {
                      context.read<TastingListBloc>().add(FilterBySearchTermEvent(keywordSearchTerm: value));
                    },
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    searchTextFieldFocusNode.requestFocus();
                    _searching = true;
                  });
                },
                child: Icon(CupertinoIcons.search, color: Colors.black, size: _searching ? 0 : 30),
              ),
              const SizedBox(width: 17),
              _searching
                  ? TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      onPressed: () {
                        setState(() {
                          // Undo search term.
                          context.read<TastingListBloc>().add(FilterBySearchTermEvent(keywordSearchTerm: ''));
                          searchTextFieldFocusNode.unfocus();
                          _searchTermController.clear();
                          _searching = false;
                        });
                      },
                      child: Text('Cancel'.toUpperCase()),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/new-wine-tasting');
                      },
                      child: Icon(CupertinoIcons.plus_app, color: Colors.black, size: 30),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Enables users to sort and filter their past tastings, while also toggling the current viewing mode.
/// Users can view their tastings in a compressed view, a card view, or as an image gallery.
class TastingListFilterSortViewBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                ),
              ],
            ),
          ),
          const SizedBox(width: 17),
          ToggleTastingListView(),
        ],
      ),
      automaticallyImplyLeading: false,
      centerTitle: false,
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

enum view { card, compressed }

/// Allows the user to toggle between a compressed and relaxed view of the list of tastings.
class ToggleTastingListView extends StatefulWidget {
  const ToggleTastingListView({Key key}) : super(key: key);

  @override
  _ToggleTastingListViewState createState() => _ToggleTastingListViewState();
}

class _ToggleTastingListViewState extends State<ToggleTastingListView> {
  view currentView = view.card;

  @override
  Widget build(BuildContext context) {
    var viewIcon;
    switch (currentView) {
      case view.card:
        viewIcon = Icon(CupertinoIcons.rectangle_grid_1x2_fill, color: Theme.of(context).colorScheme.primary);
        break;
      default:
        viewIcon = RotatedBox(
          quarterTurns: 1,
          child: Icon(CupertinoIcons.rectangle_split_3x1, color: Theme.of(context).colorScheme.primary),
        );
        break;
    }

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Wrap(
                children: [
                  ListTile(
                    leading: Icon(CupertinoIcons.rectangle_grid_1x2_fill, color: Theme.of(context).colorScheme.primary),
                    title: Text('Card View', style: Theme.of(context).textTheme.bodyText2),
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.line_horizontal_3, color: Theme.of(context).colorScheme.primary),
                    title: Text('Compressed View', style: Theme.of(context).textTheme.bodyText2),
                  )
                ],
              ),
            );
          },
        );
      },
      child: viewIcon,
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
