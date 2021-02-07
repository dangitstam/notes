import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes/src/styles/slim_rounded_rect_slider_track_shape.dart';

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

  // Buttons.
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      primary: primaryColor,
      backgroundColor: backgroundColor,
      textStyle: overline.copyWith(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(),
      side: BorderSide(width: 2, color: primaryColor),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
      primary: backgroundColor,
      backgroundColor: onSurfaceColor,
      textStyle: overline.copyWith(fontWeight: FontWeight.w400),
    ),
  ),

  // Sliders.
  sliderTheme: SliderThemeData(
    activeTrackColor: onSurfaceColor,
    inactiveTrackColor: cardColor,
    trackHeight: 24.0,
    trackShape: SlimRoundedRectSliderTrackShape(),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 14.0),
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
  fontFamily: 'Jost',
  fontSize: 24.0,
  letterSpacing: 3.6,
  fontWeight: FontWeight.w500,
);

TextStyle headline6 = const TextStyle(
  fontFamily: 'Jost',
  fontSize: 16.0,
  letterSpacing: 2.4,
  fontWeight: FontWeight.w500,
);

TextStyle bodyText2 = const TextStyle(
  fontFamily: 'Jost',
  fontSize: 14.0,
  fontWeight: FontWeight.w300,
);

TextStyle subtitle1 = const TextStyle(
  fontFamily: 'Jost',
  fontSize: 16.0,
);

TextStyle subtitle2 = GoogleFonts.inconsolata(
  fontSize: 14.0,
  fontWeight: FontWeight.w100,
);

TextStyle caption = const TextStyle(
  fontFamily: 'Jost',
  fontSize: 12.0,
  fontWeight: FontWeight.normal,
);

TextStyle overline = const TextStyle(
  fontFamily: 'Jost',
  fontSize: 12.0,
  fontWeight: FontWeight.w700,
  letterSpacing: 1.8,
);
