import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/components/characteristics/characteristics_chart.dart';
import 'package:notes/src/coffee_tasting_create_view/components/section_title.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/common/widgets/editable_text_with_caption.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';
// Heads up: Path's conflict can conflict with BuildContext's context.
import 'package:path/path.dart' show basename;

import 'components/info/image_capture.dart';

class CoffeeTastingCreateViewScreen extends StatefulWidget {
  @override
  _CoffeeTastingCreateViewScreenState createState() => _CoffeeTastingCreateViewScreenState();
}

class _CoffeeTastingCreateViewScreenState extends State<CoffeeTastingCreateViewScreen> {
  // Detect whether the characteristics section has been interacted with to undo grayscale.
  var isCharacteristicsEdited = false;

  /// Given [savedImageFilePath], a file path to the image taken/selected for the tasting, updates the tasting's image.
  void onImageSelected(String savedImageFilePath) {
    // Record file path as image for tasting.
    // Application directory changes between invocations of `flutter run`, so save the basename
    // and retrieve the application directory path at runtime to grab the image.
    context.read<CoffeeTastingCreateBloc>().add(AddImageEvent(imagePath: basename(savedImageFilePath)));
  }

  @override
  Widget build(BuildContext context) {
    var coffeeTastingState = context.watch<CoffeeTastingCreateBloc>().state.tasting;
    var selectedTastingNotes = coffeeTastingState.notes;

    return BlocListener<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
      listener: (context, state) {
        // Navigate on state change after awaited db insertion to avoid race condition.
        if (state.isCoffeeTastingInserted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'New Tasting',
            style: Theme.of(context).textTheme.bodyText2,
          ),
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
          actions: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextButton(
                style: Theme.of(context).textButtonTheme.style,
                child: Text('Create'.toUpperCase()),
                onPressed: () {
                  // Updaate app database with new tasting.
                  context.read<CoffeeTastingCreateBloc>().add(InsertCoffeeTastingEvent());
                },
              ),
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /**
                     * Image capture: Select an image for the tasting.
                     */
                    Expanded(
                      flex: 2,
                      child: ImageCapture(onImageSelected: onImageSelected),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          EditableTextWithCaptionWidget(
                            label: 'Roaster',
                            hint: 'Who roasted this coffee?',
                            onChanged: (value) {
                              context.read<CoffeeTastingCreateBloc>().add(RoasterEvent(roaster: value));
                            },
                          ),
                          SizedBox(height: 10),
                          EditableTextWithCaptionWidget(
                            label: 'Coffee Name',
                            hint: 'What kind of coffee is this?',
                            onChanged: (value) {
                              context.read<CoffeeTastingCreateBloc>().add(CoffeeNameEvent(coffeeName: value));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  minLines: 2,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a description here...',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).hintColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true),
                  onChanged: (value) {
                    context.read<CoffeeTastingCreateBloc>().add(DescriptionEvent(description: value));
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(sectionNumber: 1, title: 'Info'),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Icon(CupertinoIcons.location_solid, size: 20, color: Colors.black),
                    Text('Origin'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                          hintText: 'Ex. Idjwi Island, Congo',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          context.read<CoffeeTastingCreateBloc>().add(OriginEvent(origin: value));
                        },
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text('Process'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                    SizedBox(width: 10),
                    Container(
                      child: DropdownButton<String>(
                        value: coffeeTastingState.process,
                        icon: Icon(CupertinoIcons.chevron_down),
                        iconSize: 14,
                        style: Theme.of(context).textTheme.bodyText2,
                        underline: Container(height: 0.0),
                        onChanged: (value) {
                          context.read<CoffeeTastingCreateBloc>().add(ProcessEvent(process: value));
                        },
                        items: {
                          'Washed': Icon(CupertinoIcons.drop),
                          'Natural': Icon(CupertinoIcons.sun_min),
                        }.entries.map((entry) {
                          var processType = entry.key;
                          var processIcon = entry.value;
                          return DropdownMenuItem<String>(
                            value: processType,
                            child: Row(
                              children: [
                                processIcon,
                                Text(
                                  processType,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                SizedBox(width: 2),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text('Roast'.toUpperCase(), style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10)),
                    SizedBox(width: 20),
                    Text('Light', style: Theme.of(context).textTheme.caption),
                    Expanded(
                      flex: 1,
                      child: ThemedPaddedSlider(
                        child: Slider(
                          value: coffeeTastingState.roastLevel,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            context.read<CoffeeTastingCreateBloc>().add(RoastLevelEvent(roastLevel: round(value)));
                          },
                        ),
                      ),
                    ),
                    Text('Dark', style: Theme.of(context).textTheme.caption),
                    SizedBox(width: 20),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(sectionNumber: 2, title: 'Notes'),
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Edit'.toUpperCase()),
                      onPressed: () {
                        Navigator.pushNamed(context, '/notes');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                selectedTastingNotes.isNotEmpty
                    ? Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        spacing: 5,
                        children: selectedTastingNotes.map((e) => TastingNote(e)).toList(),
                      )
                    : Text('Tap \'edit\' to select tasting notes.'),
                SizedBox(height: 20),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(sectionNumber: 3, title: 'Characteristics'),
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Edit'.toUpperCase()),
                      onPressed: () {
                        isCharacteristicsEdited = true;
                        Navigator.pushNamed(context, '/characteristics');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                isCharacteristicsEdited
                    ? CharacteristicsChart()
                    : Column(
                        children: [
                          Text('Tap \'edit\' to assess characteristics.'),
                          SizedBox(height: 20),
                          ColorFiltered(
                            colorFilter:
                                ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.saturation),
                            child: CharacteristicsChart(),
                          ),
                        ],
                      ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
