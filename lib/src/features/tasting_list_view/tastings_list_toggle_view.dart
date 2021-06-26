import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/features/tasting_list_view/bloc/tasting_list_bloc.dart';

enum TastingListViewMode { card, compressed }

/// Allows the user to toggle between a compressed and relaxed view of the list of tastings.
class ToggleTastingListView extends StatefulWidget {
  const ToggleTastingListView({Key key}) : super(key: key);

  @override
  _ToggleTastingListViewState createState() => _ToggleTastingListViewState();
}

// Go with Spotify's tap approach?
class _ToggleTastingListViewState extends State<ToggleTastingListView> {
  TastingListViewMode currentView = TastingListViewMode.card;

  @override
  Widget build(BuildContext context) {
    var viewIcon;
    switch (currentView) {
      case TastingListViewMode.card:
        viewIcon = Icon(CupertinoIcons.square_stack, color: Theme.of(context).colorScheme.primary);
        break;
      default:
        viewIcon = Icon(CupertinoIcons.list_bullet, color: Theme.of(context).colorScheme.primary);
        break;
    }

    TastingListBloc tastingListViewBloc = BlocProvider.of<TastingListBloc>(context);

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
                  // For each option, toggle the view mode and collapse the modal.
                  ListTile(
                    leading: Icon(CupertinoIcons.square_stack, color: Theme.of(context).colorScheme.primary),
                    title: Text('Card View', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        currentView = TastingListViewMode.card;
                      });
                      tastingListViewBloc.add(ToggleTastingListViewMode(viewMode: TastingListViewMode.card));
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.list_bullet, color: Theme.of(context).colorScheme.primary),
                    title: Text('Compressed View', style: Theme.of(context).textTheme.bodyText2),
                    onTap: () {
                      setState(() {
                        currentView = TastingListViewMode.compressed;
                      });
                      tastingListViewBloc.add(ToggleTastingListViewMode(viewMode: TastingListViewMode.compressed));
                      Navigator.pop(context);
                    },
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
