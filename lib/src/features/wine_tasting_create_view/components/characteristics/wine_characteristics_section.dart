import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
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
  var swiperController = SwiperController();
  var swiperToggleButtonsSelections = [true, false, false, false, false];
  var swiperTabsTitles = [
    'Aroma',
    'Acidity',
    'Body',
    'Sweetness',
    'Finish',
  ];

  void onSwiperToggleButtonClick(int index) {
    setState(() {
      for (var i = 0; i < swiperToggleButtonsSelections.length; i++) {
        swiperToggleButtonsSelections[i] = i == index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var wineTastingState = context.watch<WineTastingCreateBloc>().state.tasting;

    var characteristics = [
      {
        'name': 'Acidity',
        'value': wineTastingState.acidityIntensity,
        'on_changed': (value) {
          context.read<WineTastingCreateBloc>().add(AcidityIntensityEvent(acidityIntensity: value.toDouble()));
        },
      },
      {
        'name': 'Sweetness',
        'value': wineTastingState.sweetnessIntensity,
        'on_changed': (value) {
          context.read<WineTastingCreateBloc>().add(SweetnessIntensityEvent(sweetnessIntensity: value.toDouble()));
        },
      },
      {
        'name': 'Astringency',
        'value': wineTastingState.acidityIntensity,
        'on_changed': (value) {
          context.read<WineTastingCreateBloc>().add(AcidityIntensityEvent(acidityIntensity: value.toDouble()));
        },
      },
      {
        'name': 'Body',
        'value': wineTastingState.bodyLevel,
        'on_changed': (value) {
          context.read<WineTastingCreateBloc>().add(BodyLevelEvent(bodyLevel: value.toDouble()));
        },
      }
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30),
      child: Column(
        children: [
          SectionTitle(sectionNumber: 2, title: 'Characteristics'),
          SizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tap any notch to note the intensity of a characteristic on a scale of zero to six with ',
                  style: Theme.of(context).textTheme.caption,
                ),
                WidgetSpan(
                  child: Icon(
                    CupertinoIcons.xmark_circle,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: '.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Tap ',
                  style: Theme.of(context).textTheme.caption,
                ),
                WidgetSpan(
                  child: Icon(
                    CupertinoIcons.xmark_circle,
                    size: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                TextSpan(
                  text: ' again to undo the mark at that position.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                String name = characteristics[index]['name'];
                double value = characteristics[index]['value'];
                var onChanged = characteristics[index]['on_changed'];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          name.toUpperCase(),
                          textAlign: TextAlign.start,
                          style: Theme.of(context).textTheme.overline,
                        ),
                        Text('${value} / 6', style: Theme.of(context).textTheme.subtitle2),
                      ],
                    ),
                    SizedBox(height: 10),
                    CharacteristicStrengthWidget(
                      value: value.toInt(),
                      onChanged: onChanged,
                    ),
                  ],
                );
              },
              separatorBuilder: (context, index) => Divider(height: 50),
              itemCount: characteristics.length,
            ),
          ),
        ],
      ),
    );
  }
}

class CharacteristicStrengthNotch extends StatefulWidget {
  final int notch_level; // The position of this notch as used in the strength widget.
  final int current_level; // The current strength level specified by the user.
  final onTap;
  CharacteristicStrengthNotch({this.notch_level, this.current_level, this.onTap});

  @override
  _CharacteristicStrengthNotchState createState() => _CharacteristicStrengthNotchState();
}

class _CharacteristicStrengthNotchState extends State<CharacteristicStrengthNotch> {
  @override
  Widget build(BuildContext context) {
    var iconData = widget.current_level >= widget.notch_level ? CupertinoIcons.xmark_circle : CupertinoIcons.minus;
    var color = widget.current_level >= widget.notch_level
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Icon(
          iconData,
          color: color,
          size: 30,
        ),
      ),
      onTap: widget.onTap,
    );
  }
}

class CharacteristicStrengthWidget extends StatefulWidget {
  int value;
  final Function(int) onChanged;
  final String weakLabel;
  final String strongLabel;
  CharacteristicStrengthWidget({
    this.value,
    this.onChanged,
    this.weakLabel = 'Weak',
    this.strongLabel = 'Strong',
  });

  @override
  _CharacteristicStrengthWidgetState createState() => _CharacteristicStrengthWidgetState();
}

class _CharacteristicStrengthWidgetState extends State<CharacteristicStrengthWidget> {
  var _selectedPosition;
  var _value;
  final _numNotches = 6;

  @override
  void initState() {
    super.initState();
    _selectedPosition = widget.value - 1;
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _numNotches,
            (index) => CharacteristicStrengthNotch(
              notch_level: index,
              current_level: _selectedPosition,
              onTap: () {
                setState(() {
                  if (_selectedPosition == index) {
                    _selectedPosition -= 1;
                  } else {
                    _selectedPosition = index;
                  }

                  // _selectedPosition is zero-indexed, bump by one to represent the actual value.
                  _value = _selectedPosition + 1;
                  widget.onChanged(_value);
                });
              },
            ),
          ),
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
