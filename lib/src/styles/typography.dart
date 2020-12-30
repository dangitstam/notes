import 'package:flutter/material.dart';

// TODO: Would defining them as constants make more sense?
TextStyle heading_5() {
  return const TextStyle(
      color: Colors.black, fontFamily: 'Baskerville', fontSize: 34.0);
}

TextStyle heading_6() {
  return const TextStyle(
      color: Colors.black, fontFamily: 'Baskerville', fontSize: 20.0);
}

TextStyle body_1(
    {Color color = Colors.black87, FontStyle fontStyle = FontStyle.normal}) {
  return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: 14.0,
      fontWeight: FontWeight.w100,
      fontStyle: fontStyle);
}

TextStyle subtitle_1({Color color = Colors.black}) {
  return TextStyle(
    color: color,
    fontFamily: 'Baskerville',
    fontSize: 14.0,
    fontWeight: FontWeight.w100,
  );
}

TextStyle caption(
    {Color color = Colors.black, FontStyle fontStyle = FontStyle.normal}) {
  return TextStyle(
      color: color,
      fontFamily: 'OpenSans',
      fontSize: 12.0,
      fontWeight: FontWeight.w100,
      fontStyle: fontStyle);
}
