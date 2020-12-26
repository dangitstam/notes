import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/data/coffee_tasting.dart';
import 'package:notes/src/styles/typography.dart';

class CoffeeTastingCreateViewWidget extends StatefulWidget {
  @override
  _CoffeeTastingCreateViewWidgetState createState() =>
      _CoffeeTastingCreateViewWidgetState();
}

class _CoffeeTastingCreateViewWidgetState
    extends State<CoffeeTastingCreateViewWidget> {
  CoffeeTasting coffeeTasting = CoffeeTasting();

  double roast_level = 8.0;

  Widget _buildEditableTextWithCaption(
      String label, String hint, Function(String) onSubmitted) {
    return Row(children: [
      Expanded(
        flex: 1,
        child: Text('$label', style: subtitle_1()),
      ),
      Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: '$hint',
            ),
            onSubmitted: (value) => onSubmitted(value),
            style: body_1(),
          ))
    ]);
  }

  Widget _buildSliderWithCaption(
      String label, String hint, Function(String) onSubmitted) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        flex: 0,
        child: Text(
          '$label',
          style: subtitle_1(),
          maxLines: 1,
        ),
      ),
      SizedBox(width: 20),
      // Expanded(
      //   flex: 1,
      //   child: Text('$roast_level / 10', style: caption()),
      // ),
      Expanded(
        flex: 1,
        child: Text('Lighter', style: caption()),
      ),
      Expanded(
          flex: 5,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.black87,
              inactiveTrackColor: Colors.black12,
              trackHeight: 1.0,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
              thumbColor: Colors.black87,
              overlayColor: Colors.grey.withAlpha(32),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
              tickMarkShape: RoundSliderTickMarkShape(),
              activeTickMarkColor: Colors.black,
              inactiveTickMarkColor: Colors.black,
              valueIndicatorTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
            child: Slider(
              value: roast_level,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (value) {
                setState(
                  () {
                    roast_level = value;
                  },
                );
              },
            ),
          )),
      Expanded(
        flex: 1,
        child: Text('Darker', style: caption()),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset('assets/images/coffee.jpg',
                          fit: BoxFit.cover))),
            ),
            SizedBox(width: 10),
            _buildEditableTextWithCaption(
                'Roaster', 'Type the name of the coffee roaster', (input) {
              coffeeTasting.roaster = input;
            }),
            _buildEditableTextWithCaption(
                'Coffee Name', 'What kind of coffee is this?', (input) {
              coffeeTasting.coffee_name = input;
            }),
            _buildEditableTextWithCaption('Process', 'Washed, Natural...',
                (input) {
              coffeeTasting.process = input;
            }),
            _buildSliderWithCaption('Roast Level', 'Washed, Natural...',
                (input) {
              coffeeTasting.process = input;
            }),
          ]),
    );
  }
}
