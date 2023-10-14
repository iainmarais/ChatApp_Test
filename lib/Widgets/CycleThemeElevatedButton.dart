// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class CycleThemeElevatedIconButton extends StatelessWidget
{
  final IconData icon;
  final String label;
  const CycleThemeElevatedIconButton({super.key,required this.label, required this.icon});

  @override
  Widget build(BuildContext context) 
  {
    return ElevatedButton.icon(
      onPressed: () {ThemeProvider.controllerOf(context).nextTheme();
      log(ThemeProvider.controllerOf(context).theme.description);
      },

      icon: Icon(icon), 
      label: Text(label));
  }
}
