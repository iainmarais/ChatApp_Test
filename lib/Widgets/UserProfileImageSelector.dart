// ignore_for_file: file_names, class_names, non_constant_identifier_names

import "dart:developer";
import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

import "../Utils/AuthManager.dart";

class UserProfileImageSelector extends StatefulWidget
{
  final authManager = AuthManager();
  final void Function(File image) onImageSelected;
  final String? currentImage;
  //Allow for a large image preview, useful for previewing them in the profile editor
  final bool? UseLargeImagePreview;
  UserProfileImageSelector({super.key, required this.onImageSelected, this.currentImage, this.UseLargeImagePreview});
  @override
  State<UserProfileImageSelector> createState() => _UserProfileImageSelectorState();
}

class _UserProfileImageSelectorState extends State<UserProfileImageSelector>
{  
  
  File? _SelectedImage;
  String? _CurrentImage;
  bool? _UseLargeImagePreview;

  @override
  void initState() 
  {
    super.initState();
    if (widget.currentImage != null)
    {
      setState(() {
        _CurrentImage = widget.currentImage!;
      });   
      log("(initState) widget.currentImage value:  ${widget.currentImage}");
    }
    if (widget.UseLargeImagePreview != null)
    {
      _UseLargeImagePreview = widget.UseLargeImagePreview!;
    }
    else
    {
      _UseLargeImagePreview = false;
    }

  }
  @override
  void didUpdateWidget(covariant UserProfileImageSelector oldWidget)
  {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentImage != widget.currentImage)
    {
      setState(() {
        _CurrentImage = widget.currentImage;
      });
    }
  }
  
  void _TakePicture() async
  {
    //Nothing too huge:
    final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150, maxWidth: 150);
    if (image == null)
    {
      return;
    }
    setState(() {
      _SelectedImage = File(image.path);
    });
    widget.onImageSelected(_SelectedImage!);
  }
  void _UploadImage() async
  {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    //if the image is null, return
    if (image == null)
    {
      return;
    }
    setState(() {
      _SelectedImage = File(image.path);
    });
    widget.onImageSelected(_SelectedImage!);
  }
  @override
  Widget build(BuildContext context)
  {
    log("(build) widget.currentImage value:  ${widget.currentImage}");
    log("(build) _CurrentImage value:  $_CurrentImage");
    return Column(
      children: [
        //Image preview:
        Container(
           width: _UseLargeImagePreview! ? 100 : 50,
           height: _UseLargeImagePreview! ? 100 : 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: _SelectedImage != null 
                ? FileImage(_SelectedImage!) 
                : _CurrentImage != null 
                  ? NetworkImage(_CurrentImage!)
                  : const AssetImage("images/chat-speechbubbles.png") as ImageProvider,
              fit: BoxFit.cover
            )
          ),
          //Set the foreground image to the one stored on the backend linked against the user profile.
        ),
        const SizedBox(height: 20),
        //Functions:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: _TakePicture,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Use camera"),
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: _UploadImage,
              icon: const Icon(Icons.image),
              label: const Text("Upload image"),
            )
          ]

        )
      ]
    );
  }
}