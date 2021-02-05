import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/sweetness.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/swiper_tabs.dart';
import 'package:notes/src/common/widgets/criteria_bar_chart.dart';

import '../section_title.dart';
import 'acidity_widget.dart';
import 'aroma_widget.dart';
import 'body_widget.dart';
import 'finish_widget.dart';

class CharacteristicsScreen extends StatefulWidget {
  @override
  _CharacteristicsScreenState createState() => _CharacteristicsScreenState();
}

class _CharacteristicsScreenState extends State<CharacteristicsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
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
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.all(10.0),
        //     child: TextButton(
        //       style: Theme.of(context).outlinedButtonTheme.style,
        //       child: Text('Next'.toUpperCase()),
        //       onPressed: () {
        //         // Updaate app database with new tasting.
        //         context.read<CoffeeTastingCreateBloc>().add(InsertCoffeeTastingEvent());
        //       },
        //     ),
        //   )
        // ],
      ),
      body: CharacteristicsSection(),
    );
  }
}

class CharacteristicsSection extends StatefulWidget {
  @override
  _CharacteristicsSectionState createState() => _CharacteristicsSectionState();
}

class _CharacteristicsSectionState extends State<CharacteristicsSection>
    with AutomaticKeepAliveClientMixin<CharacteristicsSection> {
  final scoreBarColor = Color(0xff1b1b1b);
  final intensityBarColor = Color(0xff87bd91);

  var swiperController = SwiperController();
  var swiperToggleButtonsSelections = [true, false, false, false, false];
  var swiperWidgets = [
    AromaWidget(),
    AcidityWidget(),
    BodyWidget(),
    SweetnessWidget(),
    FinishWidget(),
  ];
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
    super.build(context);

    var coffeeTastingState = context.watch<CoffeeTastingCreateBloc>().state.tasting;

    return BlocListener<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      listener: (context, state) {
        // Navigate on state change after awaited db insertion to avoid race condition.
        if (state.isCoffeeTastingInserted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SectionTitle(sectionNumber: 2, title: 'Characteristics'),
            SizedBox(height: 30),
            Text('Identify and assess attributes', style: Theme.of(context).textTheme.caption),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 10.0),
              child: CriteriaBarChart(children: [
                CriteriaBarChartData(
                  criteriaLabel: 'Aroma',
                  score: coffeeTastingState.aromaScore,
                  scoreLabel: 'Score',
                  scoreColor: Theme.of(context).colorScheme.onSurface,
                  intensity: coffeeTastingState.aromaIntensity,
                  intensityLabel: 'Intensity',
                  intensityColor: Theme.of(context).colorScheme.primary,
                ),
                CriteriaBarChartData(
                  criteriaLabel: 'Acidity',
                  score: coffeeTastingState.acidityScore,
                  scoreLabel: 'Score',
                  scoreColor: Theme.of(context).colorScheme.onSurface,
                  intensity: coffeeTastingState.acidityIntensity,
                  intensityLabel: 'Intensity',
                  intensityColor: Theme.of(context).colorScheme.primary,
                ),
                CriteriaBarChartData(
                  criteriaLabel: 'Body',
                  score: coffeeTastingState.bodyScore,
                  scoreLabel: 'Score',
                  scoreColor: Theme.of(context).colorScheme.onSurface,
                  intensity: coffeeTastingState.bodyLevel,
                  intensityLabel: 'Level',
                  intensityColor: Theme.of(context).colorScheme.primary,
                ),
                CriteriaBarChartData(
                  criteriaLabel: 'Sweetness',
                  score: coffeeTastingState.sweetnessScore,
                  scoreLabel: 'Score',
                  scoreColor: Theme.of(context).colorScheme.onSurface,
                  intensity: coffeeTastingState.sweetnessIntensity,
                  intensityLabel: 'Intensity',
                  intensityColor: Theme.of(context).colorScheme.primary,
                ),
                CriteriaBarChartData(
                  criteriaLabel: 'Finish',
                  score: coffeeTastingState.finishScore,
                  scoreLabel: 'Score',
                  scoreColor: Theme.of(context).colorScheme.onSurface,
                  intensity: coffeeTastingState.finishDuration,
                  intensityLabel: 'Duration',
                  intensityColor: Theme.of(context).colorScheme.primary,
                ),
              ]),
            ),
            SizedBox(height: 20),
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
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 0.0),
              child: SwiperTabs(
                swiperTitles: swiperTabsTitles,
                isSelected: swiperToggleButtonsSelections,
                onTap: (int index) {
                  swiperController.move(index);
                },
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
