import 'package:flutter/material.dart';

class TappTheme {
  TappTheme._(); //make the constructer private
  
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}
