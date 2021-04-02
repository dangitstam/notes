import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/info/vinification.dart';
import 'package:notes/src/features/wine_tasting_create_view/components/info/wine_type_toggle_buttons.dart';

import 'alcohol_by_volume.dart';
import 'grapes.dart';

class WineInfoScreen extends StatefulWidget {
  @override
  _WineInfoScreenState createState() => _WineInfoScreenState();
}

class _WineInfoScreenState extends State<WineInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Info',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.xmark,
            color: Theme.of(context).colorScheme.onSurface,
            size: 32,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: WineInfoSection(),
      ),
    );
  }
}

class WineInfoSection extends StatefulWidget {
  @override
  _WineInfoSectionState createState() => _WineInfoSectionState();
}

class _WineInfoSectionState extends State<WineInfoSection> {
  @override
  Widget build(BuildContext context) {
    var wineTastingState = context.watch<WineTastingCreateBloc>().state.tasting;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          WineTypeToggleButtons(),
          const SizedBox(height: 10),
          Divider(),
          const SizedBox(height: 10),
          VintageAndAlcoholByVolume(),
          const SizedBox(height: 10),
          Divider(),
          const SizedBox(height: 10),
          Grapes(),
          const SizedBox(height: 10),
          Divider(),
          const SizedBox(height: 10),
          Vinification(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
