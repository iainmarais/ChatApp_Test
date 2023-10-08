// ignore_for_file: file_names, class_names, non_constant_identifier_names

//The objective of this is to present a loading screen in the case that auth is not yet verified by the backend.
import 'package:flutter/material.dart';

class LoadScreen extends StatelessWidget 
{
  final authManager;
  const LoadScreen({required this.authManager, super.key});
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Loading..."),
      ),
      body: const Center(
        child: Text("Checking server connection status...")
      )
    );
  }
}
