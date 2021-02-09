import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_list_view/bloc/coffee_tasting_list_bloc.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';

import 'list_item_coffee_tasting.dart';

// TODO: Abstract into its own file.
class CoffeeTastingListViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            child: Container(
              color: Colors.black38,
              height: 0.20,
            ),
            preferredSize: Size.fromHeight(0.5)),
        centerTitle: false,
        elevation: 0,
        title: Text(
          'Notes'.toUpperCase(),
          style: Theme.of(context).textTheme.overline.copyWith(fontSize: 24),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Filter', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [Text('Sort', style: Theme.of(context).textTheme.caption)]))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
              child: GestureDetector(
                  onTap: () {
                    // TODO: Filter implementation.
                  },
                  child: Row(children: [
                    Icon(CupertinoIcons.search, color: Colors.black, size: 20),
                    SizedBox(width: 5),
                    Text('Search', style: Theme.of(context).textTheme.caption)
                  ]))),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
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
                              Navigator.pushNamed(context, '/create');
                            },
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: Theme.of(context).outlinedButtonTheme.style,
                            child: Text('Wine'.toUpperCase()),
                            onPressed: () {
                              // TODO: Nav to wine create view.
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
      body: CoffeeTastingListViewWidget(),
    );
  }
}

class CoffeeTastingListViewWidget extends StatelessWidget {
  CoffeeTastingListViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CoffeeTastingListBloc>(context).add(InitCoffeeTastingList());
    return StreamBuilder(
      stream: BlocProvider.of<CoffeeTastingListBloc>(context).coffeeTastings,
      builder: (context, AsyncSnapshot<List<CoffeeTasting>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var coffeeTastings = snapshot.data;
          return ListView.separated(
              itemCount: coffeeTastings == null ? 0 : coffeeTastings.length,
              itemBuilder: (BuildContext _context, int index) {
                if (coffeeTastings != null && index < coffeeTastings.length) {
                  return CoffeeTastingListItem(tasting: coffeeTastings[index]);
                } else {
                  return Text('loading');
                }
              },
              padding: const EdgeInsets.all(0.0),
              separatorBuilder: (context, index) => Divider());
        } else {
          return Text('loading');
        }
      },
    );
  }
}
