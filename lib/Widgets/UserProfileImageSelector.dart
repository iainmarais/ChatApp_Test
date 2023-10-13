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
  final String? username;
  //Allow for a large image preview, useful for previewing them in the profile editor
  final bool? UseLargeImagePreview;
  UserProfileImageSelector({super.key, this.username, required this.onImageSelected, this.currentImage, this.UseLargeImagePreview});
  @override
  State<UserProfileImageSelector> createState() => _UserProfileImageSelectorState();
}

class _UserProfileImageSelectorState extends State<UserProfileImageSelector>
{  
  File? _SelectedImage;
  String? _CurrentImage;
  bool? _UseLargeImagePreview;
  //Enable autogenerator:
  bool? UseTransparency = false;
  bool? UseInvertedColours = false;

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

  void AutoGenerateProfileImage()
  {
    String? ThemeName;
    if (Theme.of(context).brightness == Brightness.dark || UseInvertedColours==true)
    {
      ThemeName = "dark";
    }
    else
    {
      ThemeName = "light";
    }
    File image;
    if(widget.username == null || widget.username!.isEmpty)
    {
      if (UseTransparency == true)
      {
        image = File("images/avatars-src/$ThemeName/transparent/placeholder-default.png");
      }
      else
      {
        image = File("images/avatars-src/$ThemeName/placeholder-default.png");
      }
    }
    else
    {
      final initial = widget.username![0];
      if(UseTransparency == true)
      {
        image = File("images/avatars-src/$ThemeName/transparent/placeholder-$initial.png");
      }
      else
      {
      image = File("images/avatars-src/$ThemeName/placeholder-$initial.png");
      }
    }
    setState(() {
      _SelectedImage = image;
    });
    widget.onImageSelected(_SelectedImage!);
  }

  void _TakePicture() async
  {
    //Nothing too huge:
    var image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50, maxHeight: 150, maxWidth: 150);
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
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

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
    DecorationImage? decoration;
    if (_CurrentImage != null)
    {
      decoration = DecorationImage(
        image: NetworkImage(_CurrentImage!),
      );
    }
    else if (_SelectedImage != null)
    {
      decoration = DecorationImage(
        image: FileImage(_SelectedImage!),
      );  
    }
    else
    {
      decoration = const DecorationImage(
        image: AssetImage("images/chat-speechbubbles.png"),
      );
    }
    return Column(
      children: [
        //Image preview:
        Container(
           width: _UseLargeImagePreview! ? 100 : 50,
           height: _UseLargeImagePreview! ? 100 : 50,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
            image: decoration.image,
              fit: BoxFit.cover
            )
          ),
          //Set the foreground image to the one stored on the backend linked against the user profile.
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Use inverted colours:"),
            const SizedBox(width: 10),
            Checkbox(value: UseInvertedColours,
                    onChanged: (value){
                      setState(() {
                        UseInvertedColours = value;
                      });
                    }),
            const SizedBox(width: 60),
            const Text("Use transparency: "),
            const SizedBox(width: 10),
            Checkbox(value: UseTransparency, 
                    onChanged: (value){
                      setState(() {
                        UseTransparency = value;
                      });
                    })
          ],
        ),
        //Add some spacing between this and the buttons:
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
            ),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: AutoGenerateProfileImage,
              icon: const Icon(Icons.autorenew),
              label: const Text("Generate default image"),
            )
          ]

        )
      ]
    );
  }
}