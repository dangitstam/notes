import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  // Define the default TextTheme. Use this to specify the default
  // text styling for headlines, titles, bodies of text, and more.
  textTheme: TextTheme(
    headline5: headline5,
    headline6: headline6,
    bodyText2: bodyText2,
    caption: caption,
    subtitle1: subtitle1,
  ),
);

TextStyle headline5 = const TextStyle(
  color: Colors.black,
  fontFamily: 'Baskerville',
  fontSize: 34.0,
);

TextStyle headline6 = const TextStyle(
  color: Colors.black,
  fontFamily: 'Baskerville',
  fontSize: 20.0,
);

TextStyle bodyText2 = const TextStyle(
  color: Colors.black87,
  fontFamily: 'OpenSans',
  fontSize: 14.0,
  fontWeight: FontWeight.w100,
);

TextStyle subtitle1 = const TextStyle(
  color: Colors.black,
  fontFamily: 'Baskerville',
  fontSize: 14.0,
  fontWeight: FontWeight.w100,
);

TextStyle caption = const TextStyle(
  color: Colors.black,
  fontFamily: 'OpenSans',
  fontSize: 12.0,
  fontWeight: FontWeight.w100,
);
