import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

import '../section_title.dart';
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitle(sectionNumber: 1, title: 'Info'),
          const SizedBox(height: 20),
          Text(
            'Edit details about the wine.',
            style: Theme.of(context).textTheme.caption,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Grapes'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
                GrapeTextFields(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Alcohol By Volume'.toUpperCase(),
                      style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                IntrinsicWidth(
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                        child: Icon(CupertinoIcons.percent, size: 16),
                      ),
                      suffixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                      hintText: '12.5',
                      labelText: 'Percentage',
                      counterText: '',
                    ),

                    // Restrict input to numeric, 3 digits.
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    maxLength: 4,
                    style: Theme.of(context).textTheme.bodyText2,
                    onChanged: (value) {},
                    validator: (value) {
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                Text('Sugar'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                const SizedBox(width: 20),
                Text('Dry', style: Theme.of(context).textTheme.caption),
                Expanded(
                  flex: 1,
                  child: ThemedPaddedSlider(
                    child: Slider(
                      value: wineTastingState.roastLevel,
                      min: 0,
                      max: 10,
                      onChanged: (value) {
                        context.read<WineTastingCreateBloc>().add(RoastLevelEvent(roastLevel: round(value)));
                      },
                    ),
                  ),
                ),
                Text('Sweet', style: Theme.of(context).textTheme.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
