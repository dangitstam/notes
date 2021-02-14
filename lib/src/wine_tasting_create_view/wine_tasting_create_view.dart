import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/src/common/widgets/editable_text_with_caption.dart';
import 'package:notes/src/common/widgets/tasting_note.dart';
import 'package:notes/src/data/model/wine/wine_tasting.dart';
import 'package:notes/src/wine_tasting_create_view/bloc/wine_tasting_create_bloc.dart';
import 'package:notes/src/wine_tasting_create_view/components/characteristics/characteristics_chart.dart';
import 'package:notes/src/wine_tasting_create_view/components/section_title.dart';
// Heads up: Path's conflict can conflict with BuildContext's context.
import 'package:path/path.dart' show basename;

import 'components/info/image_capture.dart';

class WineTastingCreateViewScreen extends StatefulWidget {
  @override
  _WineTastingCreateViewScreenState createState() => _WineTastingCreateViewScreenState();
}

class _WineTastingCreateViewScreenState extends State<WineTastingCreateViewScreen> {
  // Detect whether the characteristics section has been interacted with to undo grayscale.
  var isCharacteristicsEdited = false;
  var isInfoEdited = false;

  /// Given [savedImageFilePath], a file path to the image taken/selected for the tasting, updates the tasting's image.
  void onImageSelected(String savedImageFilePath) {
    // Record file path as image for tasting.
    // Application directory changes between invocations of `flutter run`, so save the basename
    // and retrieve the application directory path at runtime to grab the image.
    context.read<WineTastingCreateBloc>().add(AddImageEvent(imagePath: basename(savedImageFilePath)));
  }

  String formatVarietals(WineTasting tasting) {
    if (tasting.varietals.isNotEmpty && tasting.varietalPercentages.isNotEmpty) {
      List<String> varietals = json.decode(tasting.varietals).cast<String>();
      List<int> varietalPercentages = json.decode(tasting.varietalPercentages).cast<int>();
      if (varietals.length == varietalPercentages.length) {
        List<String> res = [];
        for (var i = 0; i < varietals.length; i++) {
          final String varietal = varietals[i];
          final String varietalPercentage = varietalPercentages[i].toString();
          final String formattedVarietal = '$varietalPercentage% $varietal';
          res.add(formattedVarietal);
        }

        return res.join(', ');
      }
    }

    return '(Unspecified)';
  }

  @override
  Widget build(BuildContext context) {
    var wineTastingState = context.watch<WineTastingCreateBloc>().state.tasting;
    var selectedTastingNotes = wineTastingState.notes;

    return BlocListener<WineTastingCreateBloc, WineTastingCreateState>(
      listener: (context, state) {
        // Navigate on state change after awaited db insertion to avoid race condition.
        if (state.isWineTastingInserted) {
          Navigator.pushReplacementNamed(context, '/');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Text(
            'New Wine Tasting',
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
                  context.read<WineTastingCreateBloc>().add(InsertWineTastingEvent());
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
                            label: 'Vigneron(ne)',
                            hint: 'Who made this wine?',
                            onChanged: (value) {
                              context.read<WineTastingCreateBloc>().add(RoasterEvent(roaster: value));
                            },
                          ),
                          SizedBox(height: 10),
                          EditableTextWithCaptionWidget(
                            label: 'Wine Name',
                            hint: 'What is this wine called?',
                            onChanged: (value) {
                              context.read<WineTastingCreateBloc>().add(NameEvent(name: value));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a description here...',
                      hintStyle: Theme.of(context).textTheme.bodyText2.copyWith(color: Theme.of(context).hintColor),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true),
                  onChanged: (value) {
                    context.read<WineTastingCreateBloc>().add(DescriptionEvent(description: value));
                  },
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(CupertinoIcons.location_solid, size: 24, color: Theme.of(context).colorScheme.onSurface),
                    SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                          hintText: 'Roccatederighi, Tuscany, Italy',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          context.read<WineTastingCreateBloc>().add(OriginEvent(origin: value));
                        },
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(sectionNumber: 1, title: 'Info'),
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Edit'.toUpperCase()),
                      onPressed: () {
                        // This won't re-render unless there's been a change
                        // in `/wine-info` since exiting is simply a pop.
                        isInfoEdited = true;
                        Navigator.pushNamed(context, '/wine-info');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                // Caveat: This section won't re-render if [isInfoEdited] is changed.
                // A listener is required if the re-render is necessary when staying on the current screen.
                isInfoEdited
                    ? Container()
                    : Column(
                        children: [
                          Text('Tap \'edit\' to add info.'),
                          SizedBox(height: 10),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Grapes'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              formatVarietals(wineTastingState),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Vinification'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '(Unspecified)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Sugar'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '(Unspecified)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Type'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '(Unspecified)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Vintage'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '(Unspecified)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'ABV'.toUpperCase(),
                              style: Theme.of(context).textTheme.overline.copyWith(fontSize: 10),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '(Unspecified)',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SectionTitle(sectionNumber: 2, title: 'Notes'),
                    TextButton(
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text('Edit'.toUpperCase()),
                      onPressed: () {
                        Navigator.pushNamed(context, '/wine-notes');
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
                SizedBox(height: 10),
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
                        Navigator.pushNamed(context, '/wine-characteristics');
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                isCharacteristicsEdited
                    ? CharacteristicsChart(
                        tasting: context.watch<WineTastingCreateBloc>().state.tasting,
                      )
                    : Column(
                        children: [
                          Text('Tap \'edit\' to assess characteristics.'),
                          SizedBox(height: 20),
                          ColorFiltered(
                            colorFilter:
                                ColorFilter.mode(Theme.of(context).colorScheme.background, BlendMode.saturation),
                            child: CharacteristicsChart(
                              tasting: context.watch<WineTastingCreateBloc>().state.tasting,
                            ),
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
