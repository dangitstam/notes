import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:notes/src/common/widgets/editable_text_with_caption.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';
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

                      var characteristicName = sliders[index].name;

                      var initialValue;
                      if (wineTastingBloc.characteristics != null &&
                          wineTastingBloc.characteristics.containsKey(characteristicName) &&
                          wineTastingBloc.characteristics[characteristicName] != null) {
                        initialValue = wineTastingBloc.characteristics[characteristicName].value;
                      }

                      initialValue ??= sliders[index].min_value;

                      print(initialValue);

                      return Column(
                        children: [
                          CharacteristicStrengthWidget(
                            name: characteristicName,
                            initialValue: initialValue,
                            onChanged: (value) {
                              context.read<WineTastingCreateBloc>().add(
                                    EditCharacteristic(
                                      name: characteristicName,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Add New Characteristic'.toUpperCase()),
                      onPressed: () {
                        var wineTastingBloc = context.read<WineTastingCreateBloc>();
                        AddNewCharacteristicModal(context, wineTastingBloc);
                      },
                    ),
                  ],
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  void AddNewCharacteristicModal(BuildContext context, WineTastingCreateBloc wineTastingBloc) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        var name = 'Acidity';
        var minLabel = 'Low';
        var maxLabel = 'High';
        var minValue = 0.0;
        var maxValue = 10.0;
        var sliderValue = 0.0;

        return StatefulBuilder(builder: (BuildContext context, StateSetter modalState) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'New Characteristic',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  EditableTextWithCaptionWidget(
                    hint: 'Acidity, Sweetness, Body...',
                    label: 'Name',
                    onChanged: (value) {
                      modalState(() {
                        name = value;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditableTextWithCaptionWidget(
                              hint: 'Low, Weak, Less Intense...',
                              label: 'Minimum Label',
                              onChanged: (value) {
                                modalState(() {
                                  minLabel = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EditableTextWithCaptionWidget(
                              hint: 'High, Strong, More Intense...',
                              label: 'Maximum Label',
                              onChanged: (value) {
                                modalState(() {
                                  maxLabel = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Minimum Value'.toUpperCase(),
                                  style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '0',
                                labelText: 'Min value',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                counterText: '',
                              ),

                              // Restrict input to numeric, room for 4 digits.
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              style: Theme.of(context).textTheme.bodyText2,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Maximum Value'.toUpperCase(),
                                  style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: '10',
                                labelText: 'Max value',
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                counterText: '',
                              ),

                              // Restrict input to numeric, room for 4 digits.
                              keyboardType: TextInputType.number,
                              maxLength: 4,
                              style: Theme.of(context).textTheme.bodyText2,
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          '(Preview)',
                          style: Theme.of(context).textTheme.bodyText2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(name.toUpperCase(), style: Theme.of(context).textTheme.overline),
                  Row(
                    children: [
                      Text(
                        '$minLabel',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ThemedPaddedSlider(
                          child: Slider(
                            value: sliderValue,
                            min: 0,
                            max: 10,
                            onChanged: (value) {
                              modalState(() {
                                sliderValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$maxLabel',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      style: Theme.of(context).textButtonTheme.style,
                      onPressed: () {
                        wineTastingBloc.add(
                          AddNewCharacteristic(
                            name: name,
                            minLabel: minLabel,
                            maxLabel: maxLabel,
                            minValue: minValue,
                            maxValue: maxValue,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      child: Text('Create Characteristic'.toUpperCase()),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
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
