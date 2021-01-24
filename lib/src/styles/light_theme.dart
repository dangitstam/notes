import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  backgroundColor: Color(0xffffffff),
  cardColor: cardColor,

  // Colors
  colorScheme: ColorScheme(
    primary: primaryColor,
    onSurface: onSurfaceColor,
    background: primaryColor,
    brightness: Brightness.light,
    error: primaryColor,
    onBackground: primaryColor,
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
          overline: overline)
      .apply(
    bodyColor: onSurfaceColor,
    displayColor: onSurfaceColor,
  ),

  // Sliders.
  sliderTheme: SliderThemeData(
    activeTrackColor: onSurfaceColor,
    inactiveTrackColor: cardColor,
    trackHeight: 1.0,
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
    thumbColor: onSurfaceColor,
    overlayColor: Colors.grey.withAlpha(32),
    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
    tickMarkShape: RoundSliderTickMarkShape(),
    activeTickMarkColor: onSurfaceColor,
    inactiveTickMarkColor: onSurfaceColor,
  ),
);

Color primaryColor = Color(0xff779b85);
Color primaryVariantColor = Color(0xff809287);

Color onSurfaceColor = Color(0xff333331);
Color surfaceColor = Color(0xff222221);

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
