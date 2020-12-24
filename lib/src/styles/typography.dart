import 'package:flutter/material.dart';

TextStyle heading_5() {
  return const TextStyle(
      color: Colors.black, fontFamily: 'Baskerville', fontSize: 34.0);
}

TextStyle heading_6() {
  return const TextStyle(
      color: Colors.black, fontFamily: 'Baskerville', fontSize: 20.0);
}

TextStyle body_1({Color color = Colors.black87}) {
  return TextStyle(
    color: color,
    fontFamily: 'OpenSans',
    fontSize: 12.0,
    fontWeight: FontWeight.w100,
  );
}

TextStyle subtitle_1({Color color = Colors.black}) {
  return TextStyle(
    color: color,
    fontFamily: 'OpenSans',
    fontSize: 10.0,
    fontWeight: FontWeight.w100,
  );
}
