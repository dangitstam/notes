import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/data/model/tasting.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/features/tasting_list_view/bloc/tasting_list_bloc.dart';
import 'package:notes/src/features/tasting_list_view/list_item_wine_tasting.dart';

import 'list_item_coffee_tasting.dart';

class TastingListViewWidget extends StatelessWidget {
  TastingListViewWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<TastingListBloc>(context).add(InitTastings());
    return StreamBuilder(
      stream: BlocProvider.of<TastingListBloc>(context).tastings,
      builder: (context, AsyncSnapshot<List<Tasting>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          var tastings = snapshot.data;
          return ListView.separated(
              itemCount: tastings == null ? 0 : tastings.length,
              itemBuilder: (BuildContext _context, int index) {
                if (tastings != null && index < tastings.length) {
                  final tasting = tastings[index];
                  switch (tasting.runtimeType) {
                    case CoffeeTasting:
                      return CoffeeTastingListItem(tasting: tasting);
                    case WineTasting:
                      return WineTastingListItem(tasting: tasting);
                    default:
                      return Container();
                  }
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
