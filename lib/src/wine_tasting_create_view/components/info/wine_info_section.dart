import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/components/info/wine_type_toggle_buttons.dart';

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
  // TODO: Append to wineTastingState.
  var _isBiodynamic = false;

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Vinification'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text('Biodynamic', style: Theme.of(context).textTheme.bodyText2),
                            value: _isBiodynamic,
                            onChanged: (bool value) {
                              setState(() {
                                print(value);
                                _isBiodynamic = value;
                              });
                            },
                          ),
                          CheckboxListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text('Organic Farming', style: Theme.of(context).textTheme.bodyText2),
                            value: false,
                            onChanged: (value) {},
                          ),
                          CheckboxListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text('Unfined & Unfiltered', style: Theme.of(context).textTheme.bodyText2),
                            value: false,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CheckboxListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text('Wild Yeast', style: Theme.of(context).textTheme.bodyText2),
                            value: false,
                            onChanged: (value) {},
                          ),
                          CheckboxListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            contentPadding: EdgeInsets.all(0),
                            controlAffinity: ListTileControlAffinity.leading,
                            dense: true,
                            title: Text('No Added S02', style: Theme.of(context).textTheme.bodyText2),
                            value: false,
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
