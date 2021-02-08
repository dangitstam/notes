import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/characteristics_chart.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/swiper_tabs.dart';

import '../section_title.dart';
import 'characteristics_sliders.dart';

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

    /**
     * Pair of sliders for each characteristic.
     */
    var swiperWidgets = [
      CharacteristicsSliders(
        characteristic: 'Aroma',
        score: wineTastingState.aromaScore,
        intensity: wineTastingState.aromaIntensity,
        updateScore: (value) {
          context.read<WineTastingCreateBloc>().add(AromaScoreEvent(aromaScore: round(value)));
        },
        updateIntensity: (value) {
          context.read<WineTastingCreateBloc>().add(AromaIntensityEvent(aromaIntensity: round(value)));
        },
      ),
      CharacteristicsSliders(
        characteristic: 'Acidity',
        score: wineTastingState.acidityScore,
        intensity: wineTastingState.acidityIntensity,
        updateScore: (value) {
          context.read<WineTastingCreateBloc>().add(AcidityScoreEvent(acidityScore: round(value)));
        },
        updateIntensity: (value) {
          context.read<WineTastingCreateBloc>().add(AcidityIntensityEvent(acidityIntensity: round(value)));
        },
      ),
      CharacteristicsSliders(
        characteristic: 'Body',
        score: wineTastingState.bodyScore,
        intensity: wineTastingState.bodyLevel,
        intensitySliderLabel: 'Level',
        intensityPositiveEndLabel: Text(
          'Heavy',
          style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        intensityNegativeEndLabel: Text(
          'Thin',
          style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        updateScore: (value) {
          context.read<WineTastingCreateBloc>().add(BodyScoreEvent(bodyScore: round(value)));
        },
        updateIntensity: (value) {
          context.read<WineTastingCreateBloc>().add(BodyLevelEvent(bodyLevel: round(value)));
        },
      ),
      CharacteristicsSliders(
        characteristic: 'Sweetness',
        score: wineTastingState.sweetnessScore,
        intensity: wineTastingState.sweetnessIntensity,
        updateScore: (value) {
          context.read<WineTastingCreateBloc>().add(SweetnessScoreEvent(sweetnessScore: round(value)));
        },
        updateIntensity: (value) {
          context.read<WineTastingCreateBloc>().add(SweetnessIntensityEvent(sweetnessIntensity: round(value)));
        },
      ),
      CharacteristicsSliders(
        characteristic: 'Finish',
        score: wineTastingState.finishScore,
        intensity: wineTastingState.finishDuration,
        intensitySliderLabel: 'Duration',
        intensityPositiveEndLabel: Text(
          'Long',
          style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        intensityNegativeEndLabel: Text(
          'Short',
          style: Theme.of(context).textTheme.caption.copyWith(fontWeight: FontWeight.bold),
        ),
        updateScore: (value) {
          context.read<WineTastingCreateBloc>().add(FinishScoreEvent(finishScore: round(value)));
        },
        updateIntensity: (value) {
          context.read<WineTastingCreateBloc>().add(FinishDurationEvent(finishDuration: round(value)));
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitle(sectionNumber: 2, title: 'Characteristics'),
          SizedBox(height: 20),
          Text(
            'Identify & assess characteristics.',
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 20),
          /**
           * Chart displaying characteristic scores and intensities.
           */
          CharacteristicsChart(
            tasting: context.watch<WineTastingCreateBloc>().state.tasting,
          ),
          SizedBox(height: 20),
          /**
           * Swipeable slider section for editing characteristics.
           */
          Expanded(
            child: Swiper(
              itemCount: swiperWidgets.length,
              itemBuilder: (BuildContext context, int index) {
                return swiperWidgets[index];
              },
              control: SwiperControl(
                color: Theme.of(context).colorScheme.onSurface,
                iconNext: CupertinoIcons.chevron_right,
                iconPrevious: CupertinoIcons.chevron_left,
                padding: const EdgeInsets.all(0.0),
                size: 25,
              ),
              controller: swiperController,
              onIndexChanged: (index) => {onSwiperToggleButtonClick(index)},
            ),
          ),
          SizedBox(height: 20),
          SwiperTabs(
            swiperTitles: swiperTabsTitles,
            isSelected: swiperToggleButtonsSelections,
            onTap: (int index) {
              swiperController.move(index);
            },
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
