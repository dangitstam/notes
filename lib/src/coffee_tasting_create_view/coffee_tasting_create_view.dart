import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/interactive_tasting_note.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/acidity_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/aftertaste.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/body_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/flavor_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/aroma_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/overall.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/sweetness.dart';
import 'package:notes/src/common/util.dart';
import 'package:notes/src/common/widgets/criteria_bar_chart.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/styles/typography.dart';
// Heads up: Path's conflict can conflict with BuildContext's context.
import 'package:path/path.dart' show basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

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
    AftertasteWidget(),
  ];
  var swiperTabs = [
    Text('Aroma'),
    Text('Acidity'),
    Text('Body'),
    Text('Sweetness'),
    Text('Finish'),
  ];

  void selectSwipperToggleButton(int index) {
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          'New Tasting',
          style: body_1(),
        ),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(CupertinoIcons.xmark, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FlatButton(
                color: Colors.black,
                child: Text('Create', style: body_1(color: Colors.white)),
                onPressed: () {
                  // Updaate app database with new tasting.
                  context.read<CoffeeTastingCreateBloc>().add(InsertCoffeeTastingEvent());
                },
              ),
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
                                        title: Text('Photo Library', style: body_1()),
                                        onTap: () {
                                          getImage(ImageSource.gallery);
                                          Navigator.of(context).pop();
                                        }),
                                    ListTile(
                                      leading: Icon(CupertinoIcons.photo_camera, color: Colors.black),
                                      title: Text('Camera', style: body_1()),
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
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a description here...',
                      hintStyle: body_1(color: Color(0xff919191), fontStyle: FontStyle.italic),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true),
                  onChanged: (value) {
                    context.read<CoffeeTastingCreateBloc>().add(DescriptionEvent(description: value));
                  },
                  style: body_1(),
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
                        style: body_1(),
                      ),
                    )
                  ],
                ),
                Row(children: [
                  Text('Roast Level', style: subtitle_1()),
                  Expanded(
                    flex: 1,
                    child: BlackSliderTheme(
                      Slider(
                        value: coffeeTastingState.roastLevel,
                        min: 0,
                        max: 10,
                        divisions: 10,
                        onChanged: (value) {
                          context.read<CoffeeTastingCreateBloc>().add(RoastLevelEvent(roastLevel: value));
                        },
                      ),
                    ),
                  ),
                  Text('Process', style: subtitle_1()),
                  SizedBox(width: 10),
                  Container(
                      child: DropdownButton<String>(
                    value: coffeeTastingState.process,
                    icon: Icon(CupertinoIcons.arrow_down),
                    iconSize: 14,
                    style: body_1(),
                    underline: Container(
                      height: 0.5,
                      color: Colors.black87,
                    ),
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
                              style: body_1(),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )),
                ]),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Text('Select Notes', style: heading_6()),
                SizedBox(height: 10),
                Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  spacing: 5,
                  children: selectedTastingNotes.map((e) => RemoveTastingNote(e)).toList(),
                ),
                selectedTastingNotes.isNotEmpty
                    ? Divider(
                        height: 20,
                        indent: 60,
                        endIndent: 60,
                      )
                    : SizedBox(height: 10),
                StreamBuilder(
                  stream: BlocProvider.of<CoffeeTastingCreateBloc>(context).notes,
                  builder: (context, AsyncSnapshot<List<Note>> snapshot) {
                    var notes = snapshot.data;
                    if (notes != null) {
                      return Wrap(
                        spacing: 5,
                        alignment: WrapAlignment.center,
                        children: notes.map((e) => AddTastingNote(e)).toList(),
                      );
                    } else {
                      return Container(width: 0, height: 0);
                    }
                  },
                ),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                Text('Characteristics', style: heading_6()),
                SizedBox(height: 20),
                CriteriaBarChart(children: [
                  CriteriaBarChartData(
                    criteriaLabel: 'Aroma',
                    score: coffeeTastingState.aromaScore,
                    scoreLabel: 'Score',
                    scoreColor: scoreBarColor,
                    intensity: coffeeTastingState.aromaIntensity,
                    intensityLabel: 'Intensity',
                    intensityColor: intensityBarColor,
                  ),
                  CriteriaBarChartData(
                    criteriaLabel: 'Acidity',
                    score: coffeeTastingState.acidityScore,
                    scoreLabel: 'Score',
                    scoreColor: scoreBarColor,
                    intensity: coffeeTastingState.acidityIntensity,
                    intensityLabel: 'Intensity',
                    intensityColor: intensityBarColor,
                  ),
                  CriteriaBarChartData(
                    criteriaLabel: 'Body',
                    score: coffeeTastingState.bodyScore,
                    scoreLabel: 'Score',
                    scoreColor: scoreBarColor,
                    intensity: coffeeTastingState.bodyLevel,
                    intensityLabel: 'Level',
                    intensityColor: intensityBarColor,
                  ),
                  CriteriaBarChartData(
                    criteriaLabel: 'Sweetness',
                    score: coffeeTastingState.sweetnessScore,
                    scoreLabel: 'Score',
                    scoreColor: scoreBarColor,
                    intensity: coffeeTastingState.sweetnessIntensity,
                    intensityLabel: 'Intensity',
                    intensityColor: intensityBarColor,
                  ),
                  CriteriaBarChartData(
                    criteriaLabel: 'Finish',
                    score: coffeeTastingState.finishScore,
                    scoreLabel: 'Score',
                    scoreColor: scoreBarColor,
                    intensity: coffeeTastingState.finishDuration,
                    intensityLabel: 'Duration',
                    intensityColor: intensityBarColor,
                  ),
                ]),
                SizedBox(height: 20),
                SizedBox(
                  height: 280,
                  child: Swiper(
                    itemCount: swiperWidgets.length,
                    itemBuilder: (BuildContext context, int index) {
                      return swiperWidgets[index];
                    },
                    control: SwiperControl(
                      color: Colors.black,
                      iconNext: CupertinoIcons.chevron_right_circle_fill,
                      iconPrevious: CupertinoIcons.chevron_left_circle_fill,
                      padding: const EdgeInsets.all(0.0),
                      size: 25,
                    ),
                    controller: swiperController,
                    onIndexChanged: (index) => {selectSwipperToggleButton(index)},
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 0.0, right: 0.0),
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      final borderWidth = 1.0;
                      final numVerticalBorders = swiperTabs.length + 1;
                      return ToggleButtons(
                        borderColor: Color(0xff2C2529),
                        borderWidth: borderWidth,
                        constraints: BoxConstraints.expand(
                          // Allot space for each swiper tab, subtract width of vertical borders between each
                          // element and on the edges to avoid overflow.
                          width: constraints.maxWidth / swiperTabs.length - borderWidth * numVerticalBorders,
                          height: 48,
                        ),
                        children: swiperTabs,
                        fillColor: Colors.black,
                        isSelected: swiperToggleButtonsSelections,
                        onPressed: (int index) {
                          swiperController.move(index);
                          selectSwipperToggleButton(index);
                        },
                        selectedBorderColor: Colors.black,
                        selectedColor: Colors.white,
                        textStyle: subtitle_1(),
                      );
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
