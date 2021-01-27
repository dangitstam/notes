import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/styles/SlimSliderTrackShape.dart';

ThemeData lightTheme = ThemeData(
  // Colors
  backgroundColor: backgroundColor,
  cardColor: cardColor,
  dividerTheme: DividerThemeData(
    color: Color(0xfff1f1f1),
    thickness: 1.0,
  ),

  colorScheme: ColorScheme(
    primary: primaryColor,
    onSurface: onSurfaceColor,
    background: backgroundColor,
    brightness: Brightness.light,
    error: primaryColor,
    onBackground: onSurfaceColor,
    onError: primaryColor,
    onPrimary: primaryColor,
    onSecondary: primaryColor,
    primaryVariant: primaryVariantColor,
    secondary: primaryColor,
    secondaryVariant: primaryColor,
    surface: surfaceColor,
  ),
  hintColor: Color(0xff919191),

  // Typography.
  textTheme: TextTheme(
    headline5: headline5,
    headline6: headline6,
    bodyText2: bodyText2,
    caption: caption,
    subtitle1: subtitle1,
    subtitle2: subtitle2,
    overline: overline,
  ).apply(
    bodyColor: onSurfaceColor,
    displayColor: onSurfaceColor,
  ),

  // Sliders.
  sliderTheme: SliderThemeData(
    activeTrackColor: onSurfaceColor,
    inactiveTrackColor: cardColor,
    trackHeight: 10.0,
    trackShape: SlimRectangularSliderTrackShape(),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    thumbColor: onSurfaceColor,
    overlayColor: Colors.grey.withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
  ),
);

Color primaryColor = Color(0xff779b85);
Color primaryVariantColor = Color(0xff809287);

Color onSurfaceColor = Color(0xff333331);
Color surfaceColor = Color(0xff222221);

Color backgroundColor = Color(0xffffffff);
Color cardColor = Color(0xfff1f1f1);

TextStyle headline5 = const TextStyle(
  fontFamily: 'Baskerville',
  fontSize: 34.0,
);

TextStyle headline6 = const TextStyle(
  fontFamily: 'Baskerville',
  fontSize: 20.0,
);

TextStyle bodyText2 = const TextStyle(
  fontFamily: 'OpenSans',
  fontSize: 14.0,
  fontWeight: FontWeight.w100,
);

TextStyle subtitle1 = const TextStyle(
  fontFamily: 'Baskerville',
  fontSize: 16.0,
);

TextStyle subtitle2 = GoogleFonts.inconsolata(
  fontSize: 14.0,
  fontWeight: FontWeight.w100,
);

TextStyle caption = const TextStyle(
  fontFamily: 'OpenSans',
  fontSize: 12.0,
  fontWeight: FontWeight.w100,
);

TextStyle overline = caption.copyWith(
  fontFamily: 'OpenSans',
  fontSize: 12.0,
  fontWeight: FontWeight.w900,
  letterSpacing: 1.5,
);
