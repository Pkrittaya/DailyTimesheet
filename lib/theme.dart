import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Palette {
  static const MaterialColor colorTheme = MaterialColor(
    //0xFF722922,
    0xff961b20,
    // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xffc07679), //10%
      100: Color(0xffb65f63), //20%
      200: Color(0xffab494d), //30%
      300: Color(0xffa13236), //40%
      400: Color(0xff961b20), //50%
      500: Color(0xff78161a), //60%
      600: Color(0xff5a1013), //70%
      700: Color(0xff4b0e10), //80%
      800: Color(0xff3c0b0d), //90%
      900: Color(0xff2d080a), //100%
    },
  );
}

class Fonts {
  static String fonts = GoogleFonts.kanit().fontFamily!;
}

ThemeData basicTheme() {
  return ThemeData(
    fontFamily: GoogleFonts.kanit().fontFamily,
    // primaryColor: Color.fromRGBO(114, 41, 34, 1),
    primarySwatch: Palette.colorTheme,

    // Define the default `TextTheme`. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(
      /*displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),*/

      titleLarge: TextStyle(fontSize: 22.0),
      titleMedium: TextStyle(fontSize: 16.0, color: Colors.white),
      titleSmall: TextStyle(fontSize: 14.0),
    ),
  );
}

class Cutofftime {
  static int hours = 9;
  static int minutes = 0;
}
