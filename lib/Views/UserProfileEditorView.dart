// ignore_for_file: file_names, class_names, non_constant_identifier_names
import "dart:developer";
import 'package:flutter/material.dart';
import "package:supabase_flutter/supabase_flutter.dart";


//Other namespaces needed:
import "../Utils/AuthManager.dart";
import "../Models/ChatUserModel.dart";
import "../Widgets/UserProfileImageSelector.dart";

//The purpose of this is to present a user profile editor view with a consistent layout rather than using a popup dialog.
class UserProfileEditorView extends StatefulWidget
{
  final AuthManager authManager;
  const UserProfileEditorView({super.key, required this.authManager});

  @override
  State<UserProfileEditorView> createState() => _UserProfileEditorViewState();
}

class _UserProfileEditorViewState extends State<UserProfileEditorView>
{
  bool? IsProcessing = false;
  final newUsernameController = TextEditingController();
  final newFirstnameController = TextEditingController();
  final newSurnameController = TextEditingController();
  final newAboutController = TextEditingController();
  final newEmailAddressController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late AuthManager _authManager;
  late ChatUserModel chatUser;
  late User? user;

  //User inputs:
  String? newUsername;
  String? newFirstname;
  String? newSurname;
  String? newAbout;
  String? newEmailAddress;

  @override 
  void initState()
  {
    super.initState();
    _authManager = widget.authManager;
    user = _authManager.client!.auth.currentUser;
    chatUser = ChatUserModel(userId: user!.id);

    UpdateProfile();
  }

  void UpdateProfile() async
  {
    try
    {
      final chatUserSnapshot = await widget.authManager.client!.from("chat_users").select().eq("user_id", user?.id).single();
      if(chatUserSnapshot != null)
      {
        setState(()
        {
          IsProcessing = true;
          chatUser.username = chatUserSnapshot["username"];
          chatUser.firstname = chatUserSnapshot["firstname"];
          chatUser.surname = chatUserSnapshot["surname"];
          chatUser.about = chatUserSnapshot["about"];
          chatUser.emailAddress = chatUserSnapshot["email_address"];
          chatUser.profileImage = chatUserSnapshot["profile_image"];
          //Set the initial values of the TextFormField widgets:
          newUsername = chatUser.username ?? '';
          newFirstname = chatUser.firstname ?? '';
          newSurname = chatUser.surname ?? '';
          newAbout = chatUser.about ?? '';
          // Set the initial values of the TextEditingController
          newUsernameController.text = chatUser.username ?? '';
          newFirstnameController.text = chatUser.firstname ?? '';
          newSurnameController.text = chatUser.surname ?? '';
          newAboutController.text = chatUser.about ?? '';
          newEmailAddressController.text = chatUser.emailAddress ?? '';
          IsProcessing = false;
        });
      }
    }
    catch(ex)
    {
      //Make sure the context is still mounted
      if (!context.mounted)
      {
        return;
      }
      //If something goes wrong, I want to know about it.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Details not found, using defaults")
        )
      );
      chatUser.username = "";
      chatUser.firstname = "";
      chatUser.surname = "";
      chatUser.about = "";
      chatUser.emailAddress = "";
      chatUser.profileImage = "";
      log(ex.toString());
    }
  }

  @override
  Widget build(BuildContext context)
  {
    //Use a scaffold here - this is a new view.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Profile"),
        actions: [
          //Submit the changes:
          TextButton.icon(
            onPressed:(){
              if(formKey.currentState!.validate())
              {
                formKey.currentState!.save();
                //Update the database:
                chatUser.username = newUsername;
                chatUser.firstname = newFirstname;
                chatUser.surname = newSurname;
                chatUser.about = newAbout;
                chatUser.emailAddress = newEmailAddress;
                chatUser.profileImage = chatUser.profileImage;
                widget.authManager.UpdateUserDetails(newUsername, newFirstname, newSurname, newAbout, chatUser.profileImage, newEmailAddress);
                //Return to the previous view:
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check),
            label: const Text("Submit"),
          ),
          //Exit/return to the previous view:
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
            label: const Text("Cancel"),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: IsProcessing == true 
        ? const Column(
          children:[
            CircularProgressIndicator(),
            SizedBox(height: 20.0),
            Text("Waiting for response...")
          ]
        )
        :Column(
        children: <Widget>[
          const SizedBox(height: 14.0),
          const Text("Update your user profile details for your account."),
          const SizedBox(height: 20.0),
          UserProfileImageSelector(username: chatUser.username,onImageSelected: (profileImage)
            {
              setState(() {
                chatUser.profileImage = profileImage.path;
              });
            },
            currentImage: chatUser.profileImage,
            UseLargeImagePreview: true,
          ),
          const SizedBox(height: 10.0),
          TextFormField(
            controller: newUsernameController,
            decoration: const InputDecoration(labelText: "Username"),
            onChanged: (value) => newUsername = value,
            ),
          TextFormField(
            controller: newFirstnameController,
            decoration: const InputDecoration(labelText: "Firstname"),
            onChanged: (value) => newFirstname = value,
            ),
          TextFormField(
            controller: newSurnameController,
            decoration: const InputDecoration(labelText: "Surname"),
            onChanged: (value) => newSurname = value,
            ),
          TextFormField(
            controller: newAboutController,
            decoration: const InputDecoration(labelText: "About"),
            onChanged: (value) => newAbout = value,
            ),
          TextFormField(
            controller: newEmailAddressController,
            decoration: const InputDecoration(labelText: "Email address"),
            onChanged: (value) => newEmailAddress = value,
            ),
        ]
       )
      )
    );
  }
}