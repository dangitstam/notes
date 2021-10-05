import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:notes/src/data/model/slider/slider.dart';
import 'package:notes/src/features/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';

import '../section_title.dart';

class WineCharacteristicsScreen extends StatefulWidget {
  @override
  _WineCharacteristicsScreenState createState() => _WineCharacteristicsScreenState();
}

class _WineCharacteristicsScreenState extends State<WineCharacteristicsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Characteristics',
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
      body: CharacteristicsSection(),
    );
  }
}

class CharacteristicsSection extends StatefulWidget {
  @override
  _CharacteristicsSectionState createState() => _CharacteristicsSectionState();
}

class _CharacteristicsSectionState extends State<CharacteristicsSection> {
  @override
  Widget build(BuildContext context) {
    var wineTastingBloc = context.read<WineTastingCreateBloc>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
      child: StreamBuilder(
        stream: wineTastingBloc.sliders,
        builder: (BuildContext context, AsyncSnapshot<List<CustomSlider>> snapshot) {
          if (snapshot.hasData) {
            var sliders = snapshot.data;

            return Column(
              children: [
                SectionTitle(sectionNumber: 2, title: 'Characteristics'),
                SizedBox(height: 20),
                Text(
                  'Tap or drag to mark the intensity of a characteristic on a scale of zero to six.',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Expanded(
                  child: ListView.separated(
                    // Disable vertical scrolling so that it doesn't interfere with dragging horizontally.
                    physics: const NeverScrollableScrollPhysics(),

                    itemBuilder: (context, index) {
                      // var onChanged = characteristics[index]['on_changed'];

                      return Column(
                        children: [
                          CharacteristicStrengthWidget(
                            name: sliders[index].name,
                            initialValue: sliders[index].min_value,
                            onChanged: (value) {
                              context.read<WineTastingCreateBloc>().add(
                                    EditCharacteristic(
                                      name: sliders[index].name,
                                      value: value,
                                    ),
                                  );
                            },
                            weakLabel: sliders[index].minLabel,
                            strongLabel: sliders[index].maxLabel,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => Divider(height: 50),
                    itemCount: sliders.length,
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class CharacteristicStrengthWidget extends StatefulWidget {
  final String name;
  final double initialValue;
  final Function(double) onChanged;
  final String weakLabel;
  final String strongLabel;
  CharacteristicStrengthWidget({
    this.name,
    this.initialValue,
    this.onChanged,
    this.weakLabel = 'Weak',
    this.strongLabel = 'Strong',
  });

  @override
  _CharacteristicStrengthWidgetState createState() => _CharacteristicStrengthWidgetState();
}

class _CharacteristicStrengthWidgetState extends State<CharacteristicStrengthWidget> {
  var _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    var intensityMark = ImageIcon(
      AssetImage('assets/images/np_x.png'),
      color: Theme.of(context).colorScheme.primary,
    );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.name.toUpperCase(),
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.overline,
            ),
            Text('$_value / 6.0', style: Theme.of(context).textTheme.subtitle2),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar(
              initialRating: _value,
              direction: Axis.horizontal,
              allowHalfRating: false,
              updateOnDrag: true,
              itemCount: 6,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              glow: false,
              ratingWidget: RatingWidget(
                full: intensityMark,
                half: intensityMark,
                empty: Icon(
                  CupertinoIcons.minus,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              wrapAlignment: WrapAlignment.spaceBetween,
              onRatingUpdate: (rating) {
                setState(() {
                  _value = rating;
                  widget.onChanged(_value);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.weakLabel,
              style: Theme.of(context).textTheme.caption,
            ),
            Text(
              widget.strongLabel,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        )
      ],
    );
  }
}
