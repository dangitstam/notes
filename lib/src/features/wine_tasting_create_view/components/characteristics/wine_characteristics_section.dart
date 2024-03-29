import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:notes/src/common/widgets/editable_text_with_caption.dart';
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

    var addNewCharacteristicWidget = AddNewCharacteristicWidget(
      // When we submit the characteristic, insert it via the AddNewCharacteristic BLoC event.
      onSubmit: (name, minLabel, maxLabel) {
        wineTastingBloc.add(
          AddNewCharacteristic(
            name: name,
            minLabel: minLabel,
            maxLabel: maxLabel,
          ),
        );
      },
    );

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 50.0),
      child: StreamBuilder(
        stream: wineTastingBloc.sliders,
        builder: (BuildContext context, AsyncSnapshot<List<CustomSlider>> snapshot) {
          if (snapshot.hasData) {
            var sliders = snapshot.data;

            return Column(
              children: [
                SectionTitle(sectionNumber: 2, title: 'Characteristics'),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Tap or drag to mark the intensity of a characteristic on a scale of zero to six.',
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView.separated(
                      // Disable vertical scrolling so that it doesn't interfere with dragging horizontally.
                      // physics: const NeverScrollableScrollPhysics(),

                      itemBuilder: (context, index) {
                        var characteristicName = sliders[index].name;

                        // Collect the value for this characteristic if the user has already set it.
                        var initialValue = 0.0;
                        var characteristics = wineTastingBloc.getCharacteristics();
                        if (characteristics != null &&
                            characteristics.containsKey(characteristicName) &&
                            characteristics[characteristicName].value != null) {
                          initialValue = characteristics[characteristicName].value;
                        }

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30.0),
                              child: CharacteristicStrengthWidget(
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
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => Divider(height: 50),
                      itemCount: sliders.length,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Add New Characteristic'.toUpperCase()),
                      onPressed: () {
                        AddNewCharacteristicModal(context, addNewCharacteristicWidget);
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

  /// Provides a bottom sheet that displays the widget for constructing a new characteristic.
  /// We implement the modal to wrap a stateful widget so that it can be rebuilt while maintaining the state of
  /// the characteristic being built (e.g. a rebuild occurs when the keyboard is brought up and dismissed).
  void AddNewCharacteristicModal(BuildContext context, AddNewCharacteristicWidget widget) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return widget;
      },
    );
  }
}

/// AddNewCharacteristicWidget allows input for a new characteristic.
/// Accepts a name, minLabel, and maxLabel. When the submit button is pressed,
/// the passed `onSubmit` executes, being passed the name, minLabel, and maxLabel.
class AddNewCharacteristicWidget extends StatefulWidget {
  final Function(String name, String minLabel, String maxLabel) onSubmit;
  AddNewCharacteristicWidget({
    this.onSubmit,
  });

  @override
  _AddNewCharacteristicWidgetState createState() => _AddNewCharacteristicWidgetState();
}

class _AddNewCharacteristicWidgetState extends State<AddNewCharacteristicWidget> {
  // Init. state with reasonable defaults.
  String name = 'Acidity';
  String minLabel = 'Weak';
  String maxLabel = 'Strong';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        // Pad bottom via MediaQuery to ensure the keyboard doesn't hide the textfields.
        padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 10),
        child: Wrap(
          runSpacing: 30,
          children: <Widget>[
            ListTile(
              title: Column(children: [
                Text(
                  'New Characteristic',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Create a new characteristic by giving it a name and labels for its extremes.',
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            EditableTextWithCaptionWidget(
              hint: 'Acidity, Sweetness, Body...',
              label: 'Name',
              onChanged: (value) {
                setState(() {
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
                          setState(() {
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
                          setState(() {
                            maxLabel = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: CharacteristicStrengthWidget(
                    name: name,
                    initialValue: 0,
                    onChanged: (value) {},
                    weakLabel: minLabel,
                    strongLabel: maxLabel,
                  ),
                ),
              ],
            ),
            Center(
              child: TextButton(
                style: Theme.of(context).textButtonTheme.style,
                onPressed: () {
                  widget.onSubmit(
                    name,
                    minLabel,
                    maxLabel,
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
