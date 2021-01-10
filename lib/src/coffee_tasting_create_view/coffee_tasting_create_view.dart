import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/src/coffee_tasting_create_view/bloc/coffee_tasting_create_bloc.dart';
import 'package:notes/src/coffee_tasting_create_view/interactive_tasting_note.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/acidity_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/aftertaste.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/body_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/flavor_widget.dart';
import 'package:notes/src/coffee_tasting_create_view/sca_criteria/fragrance_widget.dart';
import 'package:notes/src/data/model/note.dart';
import 'package:notes/src/styles/typography.dart';
import 'package:notes/src/util.dart';

class CoffeeTastingCreateViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var selectedTastingNotes = context.watch<CoffeeTastingCreateBloc>().state.notes;

    final picker = ImagePicker();

    Future getImage() async {
      final pickedFile = await picker.getImage(source: ImageSource.camera);

      // TODO: Update state with File(pickedFile.path)
      // setState(() {
      //   if (pickedFile != null) {
      //     _image = File(pickedFile.path);
      //   } else {
      //     print('No image selected.');
      //   }
      // });
    }

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
      body: BlocListener<CoffeeTastingCreateBloc, CoffeeTastingCreateState>(
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
                                child: Image.asset(
                                  'assets/images/coffee.jpg',
                                  fit: BoxFit.cover,
                                ),
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
                                        // TODO: Open photo gallery and allow image selection; update state with photo file path.
                                        Navigator.of(context).pop();
                                      }),
                                  ListTile(
                                    leading: Icon(CupertinoIcons.photo_camera, color: Colors.black),
                                    title: Text('Camera', style: body_1()),
                                    onTap: () {
                                      // TODO: Open camera and allow image capture; update state with photo file path.
                                      getImage();
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
                      value: context.watch<CoffeeTastingCreateBloc>().state.roastLevel,
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
                  value: context.watch<CoffeeTastingCreateBloc>().state.process,
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
              Text('Select Notes', style: subtitle_1()),
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
              AcidityWidget(),
              Divider(),
              SizedBox(height: 10),
              AftertasteWidget(),
              Divider(),
              SizedBox(height: 10),
              BodyWidget(),
              Divider(),
              SizedBox(height: 10),
              FlavorWidget(),
              Divider(),
              SizedBox(height: 10),
              FragranceWidget(),
              Divider(),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
