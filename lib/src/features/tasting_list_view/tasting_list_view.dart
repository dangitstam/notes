import 'package:flutter/cupertino.dart';
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
          var tastings = snapshot.data;
          if (tastings.isEmpty) {
            return NoTastingsYetWidget();
          }

          return ListView.separated(
            padding: const EdgeInsets.all(0.0),
            separatorBuilder: (context, index) => Divider(),
            itemCount: tastings == null ? 0 : tastings.length,
            itemBuilder: (BuildContext _context, int index) {
              if (tastings != null && index < tastings.length) {
                return WineTastingListItem(tasting: tastings[index]);
              }
              return Container();
            },
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
