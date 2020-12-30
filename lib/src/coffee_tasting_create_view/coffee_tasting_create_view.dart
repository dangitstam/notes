import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/data/model/coffee_tasting.dart';
import 'package:notes/src/styles/typography.dart';

import '../data/coffee_tasting_repository.dart';

class CoffeeTastingCreateViewWidget extends StatefulWidget {
  @override
  _CoffeeTastingCreateViewWidgetState createState() =>
      _CoffeeTastingCreateViewWidgetState();
}

class _CoffeeTastingCreateViewWidgetState
    extends State<CoffeeTastingCreateViewWidget> {
  final coffeeTastingBloc = CoffeeTastingBloc.instance;

  String coffeeName = '';
  String description = '';
  String origin = '';
  String roaster = '';
  String process = 'Washed';
  double roastLevel = 7.0;
  double acidityScore = 7.0;
  double acidityIntensity = 7.0;
  double aftertasteScore = 7.0;
  double bodyScore = 7.0;
  double bodyLevel = 7.0;
  double flavorScore = 7.0;
  double fragranceScore = 7.0;
  double fragranceBreak = 7.0;
  double fragranceDry = 7.0;

  Widget _buildEditableTextWithCaption(
      String label, String hint, Function(String) onChanged) {
    return TextField(
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 0.1),
            ),
            contentPadding: EdgeInsets.all(0),
            hintText: hint,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: label,
            labelStyle: subtitle_1()),
        style: body_1(),
        onChanged: (value) => onChanged(value));
  }

  Widget _buildThemedSlider(Slider slider) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.black87,
        inactiveTrackColor: Colors.black12,
        trackHeight: 1.0,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.0),
        thumbColor: Colors.black87,
        overlayColor: Colors.grey.withAlpha(32),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
        tickMarkShape: RoundSliderTickMarkShape(),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: Colors.black,
      ),
      child: slider,
    );
  }

  void insertCoffeeTasting() async {
    final int coffeeTastingId = await coffeeTastingBloc.insert(CoffeeTasting(
        coffeeName: coffeeName,
        description: description,
        origin: origin,
        process: process,
        roaster: roaster,
        // notes: ['Plum', 'Chocolate', 'Black Cherry'],
        roastLevel: roastLevel / 10,
        acidity: acidityScore,
        aftertaste: aftertasteScore,
        body: bodyScore,
        flavor: flavorScore,
        fragrance: fragranceScore));
  }

  @override
  Widget build(BuildContext context) {
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
              // Navigate to the second screen using a named route.
              Navigator.pop(context);
            },
            child: Icon(CupertinoIcons.xmark,
                color: Colors.black // add custom icons also
                ),
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
                      insertCoffeeTasting();

                      // Navigate to the second screen using a named route.
                      Navigator.pop(context);
                    },
                  ),
                ))
          ],
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: AspectRatio(
                            aspectRatio: 1.0,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset('assets/images/coffee.jpg',
                                    fit: BoxFit.cover)))),
                    SizedBox(width: 10),
                    Expanded(
                        flex: 5,
                        child: Column(children: [
                          _buildEditableTextWithCaption(
                              'Roaster', 'Who roasted this coffee?', (value) {
                            roaster = value;
                          }),
                          SizedBox(height: 10),
                          _buildEditableTextWithCaption(
                              'Coffee Name', 'What kind of coffee is this?',
                              (value) {
                            coffeeName = value;
                          })
                        ]))
                  ]),
              SizedBox(height: 10),
              Row(children: [
                Expanded(
                    child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Write a description here...',
                      hintStyle: body_1(
                          color: Color(0xff919191),
                          fontStyle: FontStyle.italic),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true),
                  onChanged: (value) {
                    description = value;
                  },
                  style: body_1(),
                )),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Icon(CupertinoIcons.location_solid,
                      size: 20, color: Colors.black),
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
                      origin = value;
                    },
                    style: body_1(),
                  ))
                ]),
                Row(children: [
                  Text('Roast Level', style: subtitle_1()),
                  Expanded(
                      flex: 1,
                      child: _buildThemedSlider(Slider(
                          value: roastLevel,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          onChanged: (value) {
                            setState(() {
                              roastLevel = value;
                            });
                          }))),
                  Text('Process', style: subtitle_1()),
                  SizedBox(width: 10),
                  Container(
                      child: DropdownButton<String>(
                    value: process,
                    icon: Icon(CupertinoIcons.arrow_down),
                    iconSize: 14,
                    style: body_1(),
                    underline: Container(
                      height: 0.5,
                      color: Colors.black87,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        process = newValue;
                      });
                    },
                    items: {
                      'Washed': Icon(CupertinoIcons.drop),
                      'Natural': Icon(CupertinoIcons.sun_min)
                    }.entries.map((entry) {
                      var processType = entry.key;
                      var processIcon = entry.value;
                      return DropdownMenuItem<String>(
                        value: processType,
                        child: Row(children: [
                          processIcon,
                          Text(processType, style: body_1())
                        ]),
                      );
                    }).toList(),
                  )),
                ]),
              ]),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              /**
               * Acidity
               */
              Text('Acidity', style: subtitle_1()),
              Container(
                  height: 140,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text('Score: $acidityScore',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 1,
                        child: _buildThemedSlider(Slider(
                            value: acidityScore,
                            min: 6,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                acidityScore = value;
                              });
                            }))),
                    Text('Intensity',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 0,
                        child: Column(children: [
                          Text('High', style: caption()),
                          Expanded(
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: _buildThemedSlider(Slider(
                                    value: acidityIntensity,
                                    min: 6,
                                    max: 10,
                                    divisions: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        acidityIntensity = value;
                                      });
                                    }))),
                          ),
                          Text('Low', style: caption()),
                        ])),
                  ])),
              Divider(),
              SizedBox(height: 10),
              /**
               * Aftertaste
               */
              Text(
                'Aftertaste',
                style: subtitle_1(),
              ),
              Container(
                  height: 100,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text('Score: $aftertasteScore',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 1,
                        child: _buildThemedSlider(Slider(
                            value: aftertasteScore,
                            min: 6,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                aftertasteScore = value;
                              });
                            })))
                  ])),
              Divider(),
              SizedBox(height: 10),
              /**
               * Body
               */
              Text('Body', style: subtitle_1()),
              Container(
                  height: 140,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text('Score: $bodyScore',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 1,
                        child: _buildThemedSlider(Slider(
                            value: bodyScore,
                            min: 6,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                bodyScore = value;
                              });
                            }))),
                    Text('Level', style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 0,
                        child: Column(children: [
                          Text('Heavy', style: caption()),
                          Expanded(
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: _buildThemedSlider(Slider(
                                    value: bodyLevel,
                                    min: 6,
                                    max: 10,
                                    divisions: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        bodyLevel = value;
                                      });
                                    }))),
                          ),
                          Text('Thin', style: caption()),
                        ])),
                  ])),
              Divider(),
              SizedBox(height: 10),
              /**
               * Flavor
               */
              Text(
                'Flavor',
                style: subtitle_1(),
              ),
              Container(
                  height: 100,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text('Score: $flavorScore',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 1,
                        child: _buildThemedSlider(Slider(
                            value: flavorScore,
                            min: 6,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                flavorScore = value;
                              });
                            })))
                  ])),
              Divider(),
              SizedBox(height: 10),
              /**
               * Fragrance/Aroma
               */
              Text('Fragrance / Aroma', style: subtitle_1()),
              Container(
                  height: 140,
                  child: Row(children: [
                    SizedBox(width: 20),
                    Text('Score: $fragranceScore',
                        style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 1,
                        child: _buildThemedSlider(Slider(
                            value: fragranceScore,
                            min: 6,
                            max: 10,
                            divisions: 10,
                            onChanged: (value) {
                              setState(() {
                                fragranceScore = value;
                              });
                            }))),
                    Text('Break', style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 0,
                        child: Column(children: [
                          Text('High', style: caption()),
                          Expanded(
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: _buildThemedSlider(Slider(
                                    value: fragranceBreak,
                                    min: 6,
                                    max: 10,
                                    divisions: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        fragranceBreak = value;
                                      });
                                    }))),
                          ),
                          Text('Low', style: caption()),
                        ])),
                    Text('Dry', style: caption(), textAlign: TextAlign.right),
                    Expanded(
                        flex: 0,
                        child: Column(children: [
                          Text('High', style: caption()),
                          Expanded(
                            child: RotatedBox(
                                quarterTurns: 3,
                                child: _buildThemedSlider(Slider(
                                    value: fragranceDry,
                                    min: 6,
                                    max: 10,
                                    divisions: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        fragranceDry = value;
                                      });
                                    }))),
                          ),
                          Text('Low', style: caption()),
                        ])),
                  ])),
              Divider(),
              SizedBox(height: 10),
            ])));
  }
}
