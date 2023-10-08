// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "package:flutter/material.dart";

import "AuthManager.dart";

class ImageManager extends StatefulWidget 
{
  final AuthManager authManager;
  final storage;
  const ImageManager({required this.authManager, required this.storage, super.key});

  @override
  State<ImageManager> createState() => _ImageManagerState();
}
//Flow should be: 
  //Upload image to the server -> "images" bucket. 
  //Retrieve link to image and associate that with the user profile. 
  //Render it.
class _ImageManagerState extends State<ImageManager> 
{
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Image Manager"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("This is a place holder for an image manager/uploader.")
          ]
        )
      )
    );
  }
}