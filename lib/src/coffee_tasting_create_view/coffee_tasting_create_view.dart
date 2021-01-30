import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/acidity_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/aroma_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/body_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/finish_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/flavor_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/overall.dart';
import 'package:notes/src/coffee_tasting_create_view/criteria/sweetness.dart';
import 'package:notes/src/coffee_tasting_create_view/interactive_tasting_note.dart';
import 'package:notes/src/coffee_tasting_create_view/new_category_dialog.dart';
import 'package:notes/src/coffee_tasting_create_view/section_title.dart';
import 'package:notes/src/coffee_tasting_create_view/swiper_tabs.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/common/widgets/criteria_bar_chart.dart';
import 'package:notes/src/common/widgets/themed_padded_slider.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/data/model/note_category.dart';
// Heads up: Path's conflict can conflict with BuildContext's context.
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

import 'criteria/criteria_util.dart';

class CoffeeTastingCreateViewWidget extends StatefulWidget {
  @override
  _CoffeeTastingCreateViewWidgetState createState() => _CoffeeTastingCreateViewWidgetState();
}

class _CoffeeTastingCreateViewWidgetState extends State<CoffeeTastingCreateViewWidget> {
  File _image;
  final picker = ImagePicker();

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

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile == null) return;

    // Save the captured image to the app locally.
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocDirPath = appDocDir.path;

    var tmpFile = File(pickedFile.path);

    var pickedFileBasename = basename(pickedFile.path);
    var savePath = '$appDocDirPath/$pickedFileBasename';
    var savedFile = await tmpFile.copy(savePath);

    // Update image in the create view.
    setState(() {
      _image = File(savedFile.path);
    });

    // Record file path as image for tasting.
    // Application directory changes between invocations of `flutter run`, so save the basename
    // and retrieve the application directory path at runtime to grab the image.
    context.read<CoffeeTastingCreateBloc>().add(
          AddImageEvent(
            imagePath: basename(savedFile.path),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    var coffeeTastingState = context.watch<CoffeeTastingCreateBloc>().state.tasting;
    var selectedTastingNotes = coffeeTastingState.notes;

    return Scaffold(
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
          child: Icon(CupertinoIcons.xmark, color: Theme.of(context).colorScheme.onSurface),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: FlatButton(
              color: Theme.of(context).colorScheme.onSurface,
              child: Text('Create'.toUpperCase(),
                  style:
                      Theme.of(context).textTheme.overline.copyWith(color: Colors.white, fontWeight: FontWeight.w300)),
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
        child: BlocListener<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
          listener: (context, state) {
            // Navigate on state change after awaited db insertion to avoid race condition.
            if (state.isCoffeeTastingInserted) {
              Navigator.pushReplacementNamed(context, '/');
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.darken,
                                  ),
                                  child: _image != null
                                      ? Image.file(_image, fit: BoxFit.cover)
                                      // TODO: Take a new stub photo.
                                      : Image.asset('assets/images/coffee.jpg', fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.photo_camera,
                              color: Colors.white.withOpacity(0.7),
                              size: 40,
                            ),
                          ],
                        ),
                        onTap: () {
                          showModalBottomSheet<void>(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 30.0),
                                child: Wrap(
                                  children: <Widget>[
                                    ListTile(
                                        leading: Icon(CupertinoIcons.photo_fill, color: Colors.black),
                                        title: Text('Photo Library', style: Theme.of(context).textTheme.bodyText2),
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        }),
                                    ListTile(
                                      leading: Icon(CupertinoIcons.photo_camera, color: Colors.black),
                                      title: Text('Camera', style: Theme.of(context).textTheme.bodyText2),
                                      onTap: () {
                                        getImage(ImageSource.camera);
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
                  children: [
                    Icon(CupertinoIcons.location_solid, size: 20, color: Colors.black),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(top: 5, bottom: 5),
                          hintText: 'Origin',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          context.read<CoffeeTastingCreateBloc>().add(OriginEvent(origin: value));
                        },
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    SizedBox(width: 10),
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
                  ],
                ),
                Row(children: [
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
                ]),
                SizedBox(height: 20),
                /**
                 * Notes
                 */
                SectionTitle(sectionNumber: 1, title: 'Notes'),
                SizedBox(height: 20),
                SectionTitleDecoration(),
                SizedBox(height: 20),
                Text('Select all that apply', style: Theme.of(context).textTheme.caption),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: selectedTastingNotes.map((e) => RemoveTastingNote(e)).toList(),
                ),
                SizedBox(height: 20),
                StreamBuilder(
                  stream: BlocProvider.of<CoffeeTastingCreateBloc>(context).notesCategorized,
                  builder: (context, AsyncSnapshot<Map<NoteCategory, List<Note>>> snapshot) {
                    var notesCategorized = snapshot.data;
                    if (notesCategorized != null) {
                      return Column(
                        children: notesCategorized.entries.map((e) {
                          final category = e.key;
                          final notes = e.value;

                          // ignore: omit_local_variable_types
                          List<Widget> children = [];
                          for (var note in notes) {
                            children.add(AddTastingNote(note));
                          }
                          children.add(
                            CreateTastingNote(category),
                          );
                          return Column(
                            children: [
                              Theme(
                                // Remove borders drawn by the expansion tile.
                                data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                child: ExpansionTile(
                                  title: Text(
                                    category.name.toUpperCase(),
                                    style: Theme.of(context).textTheme.overline,
                                  ),
                                  children: [
                                    Wrap(
                                      spacing: 5,
                                      alignment: WrapAlignment.center,
                                      children: children,
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    // BLoC is out of scope for the modal since it exists outside of the widget tree.
                    final onSubmitted = (value) {
                      context.read<CoffeeTastingCreateBloc>().add(
                            CreateCoffeeTastingNoteCategoryEvent(
                              noteCategory: NoteCategory(name: value),
                            ),
                          );
                      Navigator.pop(context);
                    };
                    showDialog(
                      context: context,
                      builder: (context) {
                        return NewCategoryDialog(
                          onSubmitted: onSubmitted,
                        );
                      },
                    );
                  },
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(CupertinoIcons.add),
                      SizedBox(width: 20),
                      Text('New Note Category'.toUpperCase(), style: Theme.of(context).textTheme.overline),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                /**
                 * Characteristics
                 */
                SectionTitle(sectionNumber: 2, title: 'Characteristics'),
                SizedBox(height: 20),
                SectionTitleDecoration(),
                SizedBox(height: 20),
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
                SizedBox(
                  height: 280,
                  child: Swiper(
                    itemCount: swiperWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return swiperWidgets[index];
                    },
                    control: SwiperControl(
                      color: Theme.of(context).colorScheme.onSurface,
                      iconNext: CupertinoIcons.chevron_right_circle_fill,
                      iconPrevious: CupertinoIcons.chevron_left_circle_fill,
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
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                FlavorWidget(),
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
                OverallWidget(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
