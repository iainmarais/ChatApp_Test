// ignore_for_file: file_names, class_names, non_constant_identifier_names
import 'package:flutter/material.dart';

class ThemeController
{
  static ThemeData LightTheme = ThemeData(
    brightness: Brightness.light,
    //Other props as needed/wanted go here.
  );

  static ThemeData DarkTheme = ThemeData(
    brightness: Brightness.dark,
    //Other props as needed/wanted go here.
  );

  //Initial theme
  static ThemeData currentTheme = LightTheme;

  static void SwitchToLightTheme()
  {
    currentTheme = LightTheme;
  }
  static void SwitchToDarkTheme()
  {
    currentTheme = DarkTheme;
  }
}